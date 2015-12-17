class TrackedDirectory

  attr_reader :path

  def initialize(path)
    @path = path
  end

  def ls(show_entries: :files)
    entries = Dir.entries(@path)
    entries.delete(".")
    entries.delete("..")
    # тремя способами

    # 1(изначальный)
    # show_entries == :files
    #   entries.delete_if { |i| !File.file?("#{@path}/#{i}") }
    # else show_entries == :dirs
    #   entries.delete_if { |i| File.file?("#{@path}/#{i}") }
    # end
    # entries
    #
    # 2
    # entries.delete_if { |i| !File.file?("#{@path}/#{i}")} if show_entries == :files
    # entries.delete_if { |i| File.file?("#{@path}/#{i}")} if show_entries == :dirs
    # entries
    #
    #3
    entries.delete_if do |i|
      is_file = !File.file?("#{@path}/#{i}")
      (is_file if show_entries == :files) || (!is_file if show_entries == :dirs)
    end
    entries

    #один должен быть коротким
  end

end
