require 'json'
require 'rest-client'
require "ostruct"

def get_projects
  source = "https://gist.githubusercontent.com/diegoacuna/47740d1d76f06aa8ced9a0db448e90a5/raw/576ea6d802741c21ef600995763e69661b254fb8/coding_challenge_endpoint.json"
  response = RestClient.get(source)
  project_json = JSON.parse(response.body)
  JSON.parse(project_json.to_json, object_class: OpenStruct)
end

def most_bookmarked_projects(place, month)
  projects = get_projects
  projects.map do |project|
    bookmarks_quantity = count_bookmarks_in_month(project, month)
    if bookmarks_quantity > 0 && project.sites.include?(place)
      {
        title: project.title,
        count: bookmarks_quantity
      }
    end
  end.compact.sort_by{|project| -project[:count]}.map{|project| project[:title]}
end

def count_bookmarks_in_month(project, month)
  project.bookmarks.select {|bookmark| Date.strptime(bookmark.created_at).month == month}.count
end

def best_performant_sites(month)
  hash = {}
  projects = get_projects
  projects.each do |project|
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
  projects = get_projects
  projects.map { |project| count_bookmarks_in_month(project, month) }.sum
end