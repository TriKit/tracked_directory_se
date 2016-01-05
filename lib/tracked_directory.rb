class TrackedDirectory

  attr_reader :path

  def initialize(path)
    @path = path
  end

  def ls(filter_by_type: nil, filter_by_extension: nil, filter_by_name: nil, sort_direction: :asc)
    entries = Dir.entries(@path)
    entries.delete(".")
    entries.delete("..")

    filter_entries_by_type(entries, filter_by_type)
    sort(entries, sort_direction)
    filter(entries, filter_by_extension, filter_by_name)
  end

  private

    def filter_entries_by_type(entries, filter_by_type=nil)
      # 1(изначальный)
      # if filter_by_type == :files
      #   entries.delete_if { |i| !File.file?("#{@path}/#{i}") }
      # else filter_by_type == :dirs
      #   entries.delete_if { |i| File.file?("#{@path}/#{i}") }
      # end
      # entries

      # 2 вариант
      # entries.delete_if { |i| !File.file?("#{@path}/#{i}")} if filter_by_type == :files
      # entries.delete_if { |i| File.file?("#{@path}/#{i}")} if filter_by_type == :dirs
      # entries

      # 3 вариант
      entries.delete_if do |i|
        entry = (File.file?("#{@path}/#{i}") ? :files : :dirs)
        entry != filter_by_type
      end if [:dirs, :files].include?(filter_by_type)
    end

    def filter(entries, extension, name)
      #filter by extension
      if extension != nil
        entries = entries.select { |i| i =~/\.#{extension}/ }
      end
      #filter by name
      entries = entries.select { |i| i =~/\A#{name}/ }
      entries
    end

    def sort(entries, sort_direction=:asc)
      #sort by desc direction
      if sort_direction == :desc
        entries.sort! { |x,y| y <=> x }
      else
      #sort_by asc direction
        entries.sort
      end
    end

end
