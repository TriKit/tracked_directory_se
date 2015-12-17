require 'tracked_directory'

RSpec.describe TrackedDirectory do

  before(:each) do
    @dir1 = TrackedDirectory.new("#{Dir.pwd}/spec/test/test_dir_1")
    @dir2 = TrackedDirectory.new("#{Dir.pwd}/spec/test/test_dir_2")
  end

  after(:each) do
    File.delete("#{@dir1.path}/entries.txt") if File.exist?("#{@dir1.path}/entries.txt")
    File.delete("#{@dir2.path}/entries.txt") if File.exist?("#{@dir2.path}/entries.txt")
  end

  describe "ls method" do
    it "shows only files" do
      expect(@dir1.ls(show_entries: :files)).to eq(["test.jpg", "test.png", "test.txt"])
    end

    it "shows only subdirs" do
      expect(@dir1.ls(show_entries: :subdirs)).to eq(["A", "B", "C"])
    end

    it "shows files and subdirs" do
      expect(@dir1.ls(show_entries: :nil)).to eq(["A", "B", "C", "test.jpg", "test.png", "test.txt"])
    end

    it "sorts files and subdirs in asc direction" do
      expect(@dir1.ls(sort_direction: :asc)).to eq(["A", "B", "C", "test.jpg", "test.png", "test.txt"])
    end

    it "sorts files and subdirs in desc direction" do
      expect(@dir1.ls(sort_direction: :desc)).to eq(["test.txt", "test.png", "test.jpg", "C", "B", "A"])
    end

    it "filters by extention" do
      expect(@dir1.ls(filter_by_extension: :txt)).to eq(["test.txt"])
    end

    it "filters by name" do
      expect(@dir1.ls(filter_by_name: :test)).to eq(["test.jpg", "test.png", "test.txt"])
    end
  end


  describe "diff method" do
    it "shows added files" do
      expect(@dir2.diff(@dir1)).to include("C" => "added", "test.jpg" => "added")
    end

    it "shows deleted files" do
      expect(@dir2.diff(@dir1)).to include("F" => "deleted", "test.rb" => "deleted")
    end

    it "shows changed files" do
      @dir1.instance_variable_set(:@timestamp, @dir1.timestamp - 30)
      expect(@dir1.diff(@dir2)).to include("test.txt" => "changed")
    end
  end


  describe "save_entries method" do
    it "saves elements entries array in entries.txt in separate lines" do
      @dir1.save_entries
      loaded_entries = File.readlines("#{@dir1.path}/entries.txt")
      expect(loaded_entries).to eq(["A\n", "B\n", "C\n", "test.jpg\n", "test.png\n", "test.txt\n"])
    end
  end


  describe "load_entries method" do
    it "loads entries.txt" do
      File.open("#{@dir1.path}/entries.txt", "w") do |f|
        f.puts 'file1'
        f.puts 'file2'
      end
      @dir1.load_entries
      expect(@dir1.entries).to eq(["file1", "file2"])
    end
  end


  describe "changed? method" do
    it "shows true if compared entries aren't equal" do
      expect(@dir1.changed?(@dir2)).to be_truthy
    end

    it "shows false if compared entries are equal" do
      expect(@dir1.changed?(@dir1)).to be_falsy
    end
  end

end
