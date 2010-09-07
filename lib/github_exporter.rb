require 'nokogiri'

module GitHub
  GITHUB_XML_BASE = 'http://github.com/api/v2/xml'

  class Exporter
    def initialize(repo, login = nil, token = nil)
      @login = login || ENV['GITHUB_LOGIN']
      @token = token || ENV['GITHUB_TOKEN']

      raise ArgumentError, "Login required (pass login)" unless @login
      raise ArgumentError, "Token required (pass token)" unless @token

      issues_base = File::join GITHUB_XML_BASE, "issues/list/#{@login}/#{repo}"
      @open_issues = issues_base + '/open'
      @closed_issues = issues_base + '/closed'
      @comments_base = File::join GITHUB_XML_BASE, "issues/comments/#{@login}/#{repo}"
    end

    def export!
      @issues_doc = consolidate(@open_issues, @closed_issues)
    end

    def issues
      @issues_doc
    end
    
private    
    def post(url)
      $stderr.puts "Fetching #{url}"
      Net::HTTP.post_form(URI.parse(url), {'login' => @login, 'token' => @token})
    end

    def fetch_doc(url)
      response = nil
      while true
        response = post(url)
        if response.code == '403'
          $stderr.puts "Sleeping 10..."; sleep 10; next
        end
        break
      end

      raise RuntimeError, "Did not fetch #{url} successfully (#{response.code}) with " +
              "#{@login}/#{@token}" unless response.is_a? Net::HTTPSuccess

      Nokogiri::Slop(response.body)
    end

    def consolidate(*issue_uris)
      result = Nokogiri::XML.parse '<issues />'
      issue_uris.each do |url|
        fetch_doc(url).css('issue').each do |issue|
          if issue.comments.content.to_i > 0 then
            issue.comments.unlink

            comments_doc = fetch_doc("#{@comments_base}/#{issue.number.content}")
            comments_doc.comments.parent = issue
          end
          result.root << issue
        end
      end
      result
    end
  end
end
