class TabulaRasa::Spec < MiniTest::Spec
  include ActionView::Helpers::CaptureHelper
  include ActionView::Helpers::TagHelper
  include ActionView::Helpers::TextHelper
  include ActionView::Helpers::OutputSafetyHelper
  include TabulaRasa::Helpers

  attr_accessor :output_buffer

  before do
    @output_buffer = ActionView::OutputBuffer.new
  end

  def extract_first(selector, html_string)
    document_fragment_for(html_string).css(selector).first
  end

  def extract_all(selector, html_string)
    document_fragment_for(html_string).css(selector)
  end

  def document_fragment_for(html_string)
    Nokogiri::HTML::DocumentFragment.parse(html_string)
  end
end

MiniTest::Spec.register_spec_type /TabulaRasa/, TabulaRasa::Spec
