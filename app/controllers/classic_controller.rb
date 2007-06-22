class ClassicController < ApplicationController
    def list
        @list = Lister.new params[:path]
    end
end


class Folder
    def initialize(root, relative_path)
        @root = root
        @relative_path = relative_path
        @contents = []
    end

    def <<(thing)
        if thing.is_a? Folder or thing.is_a? MP3File
            @contents << thing
        end
    end

    def each(&block)
        @contents.each(&block)
    end
end

class MP3File
    def initialize(folder, filename)
        @folder = folder
        @filename = filename
    end
end
