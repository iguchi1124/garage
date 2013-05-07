require 'spec_helper'

describe Garage::NestedFieldQuery::Parser do
  let(:parser) { Garage::NestedFieldQuery::Parser.new }
  let(:builder) { Garage::NestedFieldQuery::Builder.new }

  samples =[
    [ '*',                      {'*'=>nil} ],
    [ '*,id',                   {'*'=>nil, 'id'=>nil} ],
    [ 'id',                     {'id'=>nil} ],
    [ 'id,name',                {'id'=>nil, 'name'=>nil} ],
    [ 'foo,bar[baz],quux',      {'foo'=>nil, 'bar' => {'baz'=>nil}, 'quux'=>nil} ],
    [ 'foo,bar[baz,quux],doo',  {'foo'=>nil, 'bar' => {'baz'=>nil, 'quux'=>nil}, 'doo'=>nil} ],
    [ 'foo,bar[baz[quux]],doo', {'foo'=>nil, 'bar' => {'baz' => {'quux'=>nil}}, 'doo'=>nil} ],
  ]

  fail_samples = [
    'id,,name',
    'id,name,',
    'foo[bar,]',
    'foo]',
    'foo[',
  ]

  samples.each do |fields, expected|
    it "parses fields=#{fields}" do
      parser.parse(fields).should == expected
    end

    it "roundtrips #{fields}" do
      builder.build(expected).should == fields
    end
  end

  fail_samples.each do |field|
    it "fails to parse fields=#{field}" do
      expect { parser.parse(field) }.to raise_error(Garage::NestedFieldQuery::InvalidQuery)
    end
  end
end
