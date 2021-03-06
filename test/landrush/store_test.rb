require 'test_helper'

module Landrush
  describe Store do
    before {
      @store = Store.new(Tempfile.new(%w[landrush_test_store .json]))
    }

    after {
      @store.backing_file.unlink
    }

    describe "set" do
      it "sets the key to the value and makes it available for getting" do
        @store.set('foo', 'bar')

        @store.get('foo').must_equal 'bar'
      end

      it "allows updating keys that already exist" do
        @store.set('foo', 'bar')
        @store.set('foo', 'qux')

        @store.get('foo').must_equal 'qux'
      end
    end

    describe "get" do
      it "returns nil for unset values" do
        @store.get('notakey').must_equal nil
      end

      it "returns the latest set value (no caching)" do
        @store.set('foo', 'first')
        @store.get('foo').must_equal 'first'
        @store.set('foo', 'second')
        @store.get('foo').must_equal 'second'
        @store.delete('foo')
        @store.get('foo').must_equal nil
      end
    end

    describe "delete" do
      it "removes the key from the store" do
        @store.set('now', 'you see me')

        @store.get('now').must_equal 'you see me'

        @store.delete('now')

        @store.get('now').must_equal nil # you don't!
      end
    end
  end
end
