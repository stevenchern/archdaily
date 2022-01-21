require 'json'
require 'rest-client'
require "ostruct"

class Project
  attr_reader :id, :title, :featured_image, :content, :created_at, :sites, :pageviews, :sites, :bookmarks

  def initialize(attributes = {})
    @id = attributes[:id]
    @title = attributes[:title]
    @featured_image = attributes[:featured_image]
    @content = attributes[:content]
    @created_at = attributes[:created_at]
    @pageviews = attributes[:pageviews]
    @sites = attributes[:sites]
    @bookmarks = []
    attributes[:bookmarks]&.each do |bookmark|
      @bookmarks << Bookmark.new(bookmark)
    end
  end

  class Bookmark
    attr_reader :id, :user, :created_at, :folder

    def initialize(attributes = {})
      @id = attributes[:id]
      @user = attributes[:user]
      @created_at = attributes[:created_at]
      @folders = attributes[:folders]
    end
  end

  def count_bookmarks_in_month(month)
    self.bookmarks.select {|bookmark| Date.strptime(bookmark.created_at).month == month}.count
  end
end

def get_projects
  source = "https://gist.githubusercontent.com/diegoacuna/47740d1d76f06aa8ced9a0db448e90a5/raw/576ea6d802741c21ef600995763e69661b254fb8/coding_challenge_endpoint.json"
  response = RestClient.get(source)
  project_json = JSON.parse(response.body)
  JSON.parse(project_json.to_json, object_class: OpenStruct).map do |hash|
    instance_variable_set("@project", Project.new(hash))
  end
end

def most_bookmarked_projects(place, month)
  get_projects.select { |project| project.count_bookmarks_in_month(month) > 0 && project.sites.include?(place) }
    .sort_by { |project| -project.count_bookmarks_in_month(month) }
    .map { |project| project.title }
end

def best_performant_sites(month)
  hash = {}
  get_projects.each do |project|
    if Date.strptime(project.created_at).month == month
      project.sites.each do |site|
        hash[site] ||= 0
        hash[site] += project.pageviews
      end
    end
  end
  hash.sort_by { |key, value| -value }
end

def bookmarks_per_month(month)
  get_projects.map { |project| project.count_bookmarks_in_month(month) }.sum
end