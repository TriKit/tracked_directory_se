require 'tracked_directory'
require 'fileutils'

RSpec.describe TrackedDirectory do

  before(:all) do
    test_dir_path = File.dirname(__FILE__) + "/test"
    FileUtils.rm_rf "#{test_dir_path}"
      Dir.mkdir(test_dir_path)
      Dir.mkdir("#{test_dir_path}/test_dir_1")
        Dir.mkdir("#{test_dir_path}/test_dir_1/A")
        Dir.mkdir("#{test_dir_path}/test_dir_1/B")
        Dir.mkdir("#{test_dir_path}/test_dir_1/C")
        File.new("#{test_dir_path}/test_dir_1/test.jpg", "w")
        File.new("#{test_dir_path}/test_dir_1/test.png", "w")
        File.new("#{test_dir_path}/test_dir_1/test.txt", "w")

      Dir.mkdir("#{test_dir_path}/test_dir_2")
        Dir.mkdir("#{test_dir_path}/test_dir_2/A")
        Dir.mkdir("#{test_dir_path}/test_dir_2/B")
        Dir.mkdir("#{test_dir_path}/test_dir_2/F")
        File.new("#{test_dir_path}/test_dir_2/test.rb", "w")
        File.new("#{test_dir_path}/test_dir_2/test.png", "w")
        File.new("#{test_dir_path}/test_dir_2/test.txt", "w")

    @dir1 = TrackedDirectory.new("#{test_dir_path}/test_dir_1")
    @dir2 = TrackedDirectory.new("#{test_dir_path}/test_dir_2")
  end

  describe "ls method" do
    it "shows only files" do
      expect(@dir1.ls(filter_by_type: :files)).to eq(["test.jpg", "test.png", "test.txt"])
    end

    it "shows only directories" do
      expect(@dir1.ls(filter_by_type: :dirs)).to eq(["A", "B", "C"])
    end

    it "shows files and directories" do
      expect(@dir1.ls(filter_by_type: nil)).to eq(["A", "B", "C", "test.jpg", "test.png", "test.txt"])
    end

    it "sorts files and directories in asc direction" do
      expect(@dir1.ls(sort_direction: :asc)).to eq(["A", "B", "C", "test.jpg", "test.png", "test.txt"])
    end

    it "sorts files and directories in desc direction" do
      expect(@dir1.ls(sort_direction: :desc)).to eq(["test.txt", "test.png", "test.jpg", "C", "B", "A"])
    end
    #доделать
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
