require_relative '../../test_helper'

module SamlTool
  class ReaderTest < Minitest::Test

    def test_reader
      config = Settings.new(
        foo: 'level_one/foo[1]/text()'
      )
      reader = Reader.new(nested_saml, config)
      assert_equal 'bar', reader.foo
    end

    def test_reader_with_string_hash_config
      reader = Reader.new(
                 nested_saml,
                 'foo' => 'level_one/foo[1]/text()'
               )
      assert_equal 'bar', reader.foo
    end

    def test_reader_can_get_attribute
      reader = Reader.new(
                 nested_saml,
                 'foo' => 'level_one/foo[1]/@this'
               )
      assert_equal 'that', reader.foo
    end

    def test_to_hash
      reader = Reader.new(
        nested_saml,
        {
          foo: 'level_one/foo[1]/text()',
          this: 'level_one/foo[1]/@this'
        }
      )
      expected = {
        foo: 'bar',
        this: 'that'
      }
      assert_equal expected, reader.to_hash
    end
    
    class FooReader < Reader
      def initialize(saml)
        super(
          saml,
          {
            foo: 'level_one/foo[1]/text()',
            this: 'level_one/foo[1]/@this'
          }
        )
      end
    end

    def test_reader_via_inherited_class
      reader = FooReader.new(nested_saml)
      assert_equal 'bar', reader.foo
      assert_equal 'that', reader.this
    end

    def nested_saml
      '<level_one><foo this="that">bar</foo></level_one>'
    end

  end
end
