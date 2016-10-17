require 'spec_helper'

describe 'svg helper' do
  it 'generates a string' do
    expect(svg('test', 'value')).to be_a String
  end

  it 'takes subject and value' do
    expect(svg('test', 'value')).to be_a String
  end

  it 'takes subject, value and color' do
    expect(svg('test', 'value', 'green')).to be_a String
  end

  it 'generates predefined color' do
    expect(svg('test', 'value', 'green')).to match(/#97CA00/)
  end

  it 'passes hex color' do
    expect(svg('test', 'value', '#012345')).to match(/#012345/)
  end

  it 'generates subject and value width' do
    expect(text_width('test')).to eq 20
    expect(text_width('value')).to eq 30
    expect(text_width('testvalue')).to eq 50
  end

  it 'generates box based on subject and value size plus some margins' do
    expect(svg('test', 'value', 'green')).to match(/width="70"/)
    expect(svg('testisbigger', 'newvalue', 'green')).to match(/width="130"/)
  end

  it 'resizes subject box' do
    expect(svg('test', 'value', 'green')).to match(/d=" M0,0 h30 v20 H0 Z"/)
    expect(svg('testisbigger', 'newvalue', 'green'))
      .to match(/d=" M0,0 h70 v20 H0 Z"/)
  end

  it 'resizes value box' do
    expect(svg('test', 'value', 'green')).to match(/d=" M30,0 h40 v20 H30 Z"/)
    expect(svg('testisbigger', 'newvalue', 'green'))
      .to match(/d=" M70,0 h60 v20 H70 Z"/)
  end

  it 'positions the subject' do
    expect(svg('test', 'value', 'green')).to match(/x="15" y="15"/)
    expect(svg('testisbigger', 'newvalue', 'green')).to match(/x="35" y="15"/)
  end

  it 'positions the value' do
    expect(svg('test', 'value', 'green')).to match(/x="50" y="15"/)
    expect(svg('testisbigger', 'newvalue', 'green')).to match(/x="100" y="15"/)
  end
end
