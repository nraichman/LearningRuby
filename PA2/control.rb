require "./validator.rb"
class Control
    def self.run(base_file, test_file)
        validator = Validator.new(base_file, test_file)
        return validator.validate()
    end
end