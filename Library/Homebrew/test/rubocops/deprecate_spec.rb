# frozen_string_literal: true

require "rubocops/deprecate"

describe RuboCop::Cop::FormulaAudit::DeprecateDate do
  subject(:cop) { described_class.new }

  context "When auditing formula for deprecate! date:" do
    it "deprecation date is not ISO 8601 compliant" do
      expect_offense(<<~RUBY)
        class Foo < Formula
          url 'https://brew.sh/foo-1.0.tgz'
          deprecate! date: "June 25, 2020"
                           ^^^^^^^^^^^^^^^ Use `2020-06-25` to comply with ISO 8601
        end
      RUBY
    end

    it "deprecation date is not ISO 8601 compliant with reason" do
      expect_offense(<<~RUBY)
        class Foo < Formula
          url 'https://brew.sh/foo-1.0.tgz'
          deprecate! because: "is broken", date: "June 25, 2020"
                                                 ^^^^^^^^^^^^^^^ Use `2020-06-25` to comply with ISO 8601
        end
      RUBY
    end

    it "deprecation date is ISO 8601 compliant" do
      expect_no_offenses(<<~RUBY)
        class Foo < Formula
          url 'https://brew.sh/foo-1.0.tgz'
          deprecate! date: "2020-06-25"
        end
      RUBY
    end

    it "deprecation date is ISO 8601 compliant with reason" do
      expect_no_offenses(<<~RUBY)
        class Foo < Formula
          url 'https://brew.sh/foo-1.0.tgz'
          deprecate! because: "is broken", date: "2020-06-25"
        end
      RUBY
    end

    it "no deprecation date" do
      expect_no_offenses(<<~RUBY)
        class Foo < Formula
          url 'https://brew.sh/foo-1.0.tgz'
          deprecate!
        end
      RUBY
    end

    it "no deprecation date with reason" do
      expect_no_offenses(<<~RUBY)
        class Foo < Formula
          url 'https://brew.sh/foo-1.0.tgz'
          deprecate! because: "is broken"
        end
      RUBY
    end

    it "auto corrects to ISO 8601 format" do
      source = <<~RUBY
        class Foo < Formula
          url 'https://brew.sh/foo-1.0.tgz'
          deprecate! date: "June 25, 2020"
        end
      RUBY

      corrected_source = <<~RUBY
        class Foo < Formula
          url 'https://brew.sh/foo-1.0.tgz'
          deprecate! date: "2020-06-25"
        end
      RUBY

      new_source = autocorrect_source(source)
      expect(new_source).to eq(corrected_source)
    end

    it "auto corrects to ISO 8601 format with reason" do
      source = <<~RUBY
        class Foo < Formula
          url 'https://brew.sh/foo-1.0.tgz'
          deprecate! because: "is broken", date: "June 25, 2020"
        end
      RUBY

      corrected_source = <<~RUBY
        class Foo < Formula
          url 'https://brew.sh/foo-1.0.tgz'
          deprecate! because: "is broken", date: "2020-06-25"
        end
      RUBY

      new_source = autocorrect_source(source)
      expect(new_source).to eq(corrected_source)
    end
  end
end

describe RuboCop::Cop::FormulaAudit::DeprecateReason do
  subject(:cop) { described_class.new }

  context "When auditing formula for deprecate! because:" do
    it "deprecation reason is acceptable" do
      expect_no_offenses(<<~RUBY)
        class Foo < Formula
          url 'https://brew.sh/foo-1.0.tgz'
          deprecate! because: "is broken"
        end
      RUBY
    end

    it "deprecation reason is acceptable with date" do
      expect_no_offenses(<<~RUBY)
        class Foo < Formula
          url 'https://brew.sh/foo-1.0.tgz'
          deprecate! date: "2020-08-28", because: "is broken"
        end
      RUBY
    end

    it "deprecation reason is absent" do
      expect_offense(<<~RUBY)
        class Foo < Formula
          url 'https://brew.sh/foo-1.0.tgz'
          deprecate!
          ^^^^^^^^^^ Add a reason for deprecation: `deprecate! because: "..."`
        end
      RUBY
    end

    it "deprecation reason is absent with date" do
      expect_offense(<<~RUBY)
        class Foo < Formula
          url 'https://brew.sh/foo-1.0.tgz'
          deprecate! date: "2020-08-28"
          ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Add a reason for deprecation: `deprecate! because: "..."`
        end
      RUBY
    end

    it "deprecation reason starts with `it`" do
      expect_offense(<<~RUBY)
        class Foo < Formula
          url 'https://brew.sh/foo-1.0.tgz'
          deprecate! because: "it is broken"
                              ^^^^^^^^^^^^^^ Do not start the reason with `it`
        end
      RUBY
    end

    it "deprecation reason starts with `it` with date" do
      expect_offense(<<~RUBY)
        class Foo < Formula
          url 'https://brew.sh/foo-1.0.tgz'
          deprecate! date: "2020-08-28", because: "it is broken"
                                                  ^^^^^^^^^^^^^^ Do not start the reason with `it`
        end
      RUBY
    end

    it "deprecation reason ends with a period" do
      expect_offense(<<~RUBY)
        class Foo < Formula
          url 'https://brew.sh/foo-1.0.tgz'
          deprecate! because: "is broken."
                              ^^^^^^^^^^^^ Do not end the reason with a punctuation mark
        end
      RUBY
    end

    it "deprecation reason ends with an exclamation point" do
      expect_offense(<<~RUBY)
        class Foo < Formula
          url 'https://brew.sh/foo-1.0.tgz'
          deprecate! because: "is broken!"
                              ^^^^^^^^^^^^ Do not end the reason with a punctuation mark
        end
      RUBY
    end

    it "deprecation reason ends with a question mark" do
      expect_offense(<<~RUBY)
        class Foo < Formula
          url 'https://brew.sh/foo-1.0.tgz'
          deprecate! because: "is broken?"
                              ^^^^^^^^^^^^ Do not end the reason with a punctuation mark
        end
      RUBY
    end

    it "deprecation reason ends with a period with date" do
      expect_offense(<<~RUBY)
        class Foo < Formula
          url 'https://brew.sh/foo-1.0.tgz'
          deprecate! date: "2020-08-28", because: "is broken."
                                                  ^^^^^^^^^^^^ Do not end the reason with a punctuation mark
        end
      RUBY
    end

    it "auto corrects to remove `it`" do
      source = <<~RUBY
        class Foo < Formula
          url 'https://brew.sh/foo-1.0.tgz'
          deprecate! because: "it is broken"
        end
      RUBY

      corrected_source = <<~RUBY
        class Foo < Formula
          url 'https://brew.sh/foo-1.0.tgz'
          deprecate! because: "is broken"
        end
      RUBY

      new_source = autocorrect_source(source)
      expect(new_source).to eq(corrected_source)
    end

    it "auto corrects to remove punctuation" do
      source = <<~RUBY
        class Foo < Formula
          url 'https://brew.sh/foo-1.0.tgz'
          deprecate! because: "is broken."
        end
      RUBY

      corrected_source = <<~RUBY
        class Foo < Formula
          url 'https://brew.sh/foo-1.0.tgz'
          deprecate! because: "is broken"
        end
      RUBY

      new_source = autocorrect_source(source)
      expect(new_source).to eq(corrected_source)
    end
  end
end
