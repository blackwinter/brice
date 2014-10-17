describe Brice::History do

  def hist
    @hist_store ||= []
  end

  def init_hist(opt = {})
    @hist = Brice::History.new(opt.merge(path: @path), hist)
  end

  def saved_hist
    @hist.send(:save_history)
    File.read(@path)
  end

  def compare_hist(input, result = input, saved = result)
    input.each { |i| hist.push(i) }
    hist.should == result
    saved_hist.should == saved.map { |i| "#{i}\n" }.join
  end

  describe 'no uniq, no merge' do

    before do
      init_hist(uniq: false, merge: false)
    end

    example { compare_hist(%w[]) }
    example { compare_hist(%w[1]) }
    example { compare_hist(%w[1 2 3]) }
    example { compare_hist(%w[1] * 3, %w[1 1 1]) }
    example { compare_hist(%w[1 2 3 1], %w[1 2 3 1]) }

  end

  describe 'uniq, no merge' do

    before do
      init_hist(uniq: true, merge: false)
    end

    example { compare_hist(%w[]) }
    example { compare_hist(%w[1]) }
    example { compare_hist(%w[1 2 3]) }
    example { compare_hist(%w[1] * 3, %w[1 1 1], %w[1]) }
    example { compare_hist(%w[1 2 3 1], %w[1 2 3 1], %w[1 2 3]) }

  end

  describe 'uniq, merge' do

    before do
      init_hist(uniq: true, merge: true)
    end

    example { compare_hist(%w[]) }
    example { compare_hist(%w[1]) }
    example { compare_hist(%w[1 2 3]) }
    example { compare_hist(%w[1] * 3, %w[1]) }

    # TODO: describe merging

  end

  describe 'reverse uniq, no merge' do

    before do
      init_hist(uniq: :reverse, merge: false)
    end

    example { compare_hist(%w[]) }
    example { compare_hist(%w[1]) }
    example { compare_hist(%w[1 2 3]) }
    example { compare_hist(%w[1] * 3, %w[1 1 1], %w[1]) }
    example { compare_hist(%w[1 2 3 1], %w[1 2 3 1], %w[2 3 1]) }

  end

  describe 'reverse uniq, merge' do

    before do
      init_hist(uniq: :reverse, merge: true)
    end

    example { compare_hist(%w[]) }
    example { compare_hist(%w[1]) }
    example { compare_hist(%w[1 2 3]) }
    example { compare_hist(%w[1] * 3, %w[1]) }
    example { compare_hist(%w[1 2 3 1], %w[2 3 1]) }

    # TODO: describe merging

  end

end
