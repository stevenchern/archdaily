require "project"

describe 'Project class' do
  it 'should be of class project' do
    expect(Project.new).to be_a Project
  end
end

describe 'Bookmark class' do
  new_bookmark = Project::Bookmark.new(id: 2)
  it 'should be of class project' do
    expect(new_bookmark).to be_a Project::Bookmark
  end

  it 'should have return id when asked' do
    expect(new_bookmark.id).to eq(2) 
  end
end

describe "Bookmarked projects" do
  it 'should return an array' do
    expect(most_bookmarked_projects('cl', 6)).to be_a Array
  end

  it 'should return sorted in descending order most bookmareded project titles in Chile, in June' do
    expect(most_bookmarked_projects('cl', 6)).to match_array ["Campus Quiksilver Na Pali / Patrick Arotcharen", "ZOOCO / ZOOCO Estudio", "Bulleit Frontier Works bar / FAR rohn&rojas"]
  end

  it 'should return sorted in descending order most bookmareded project titles of the rest of the world, in May' do
    expect(most_bookmarked_projects('us', 5)).to match_array ["Gabriela Mistral Cultural Center / Cristián Fernández Arquitectos + Lateral Arquitectura & Diseño"]
  end

  it 'should return sorted in descending order most bookmareded project titles of the rest of the world, in April' do
    expect(most_bookmarked_projects('us', 4)).to match_array(["Gabriela Mistral Cultural Center / Cristián Fernández Arquitectos + Lateral Arquitectura & Diseño"])
  end

  it 'should return empty array of most bookmareded titles in Colombia, in April' do
    expect(most_bookmarked_projects('co', 4)).to eq([])
  end
end

describe "Best performant sites" do
  it 'should return an array' do
    expect(best_performant_sites(6)).to be_a Array
  end

  it 'should return sorted array of country and pages read in June' do
    expect(best_performant_sites(6)).to eq([["cl", 39870], ["pe", 24403], ["co", 24403], ["mx", 24403], ["us", 15467]])
  end

  it 'should return empty array when getting information of May' do
    expect(best_performant_sites(5)).to eq([])
  end

  it "should return only the rest of the world and it's pages read when getting information of october" do
    expect(best_performant_sites(10)).to eq([["us", 1098762]])
  end
end

describe 'Count books in month' do 
  it 'should receive 1 parameters' do
    expect(Project.new().method(:count_bookmarks_in_month).arity).to eq(1)
  end

  it 'should receive return an integer' do
    expect(Project.new.count_bookmarks_in_month(6)).to be_a Integer
  end
end

describe "Count bookmarks per month" do
  it 'should return an integer' do
    expect(bookmarks_per_month(6)).to be_a Integer
  end

  it 'should return number of bookmarks in June' do
    expect(bookmarks_per_month(6)).to eq(9)
  end

  it 'should return number of bookmarks in May' do
    expect(bookmarks_per_month(5)).to eq(2)
  end

  it 'should return number of bookmarks in April' do
    expect(bookmarks_per_month(4)).to eq(1)
  end

  it 'should return number of bookmarks in March' do
    expect(bookmarks_per_month(3)).to eq(0)
  end
end

describe "Get JSON from url" do
  it 'should parse and be an Array' do
    expect(get_projects).to be_a Array
  end
end
