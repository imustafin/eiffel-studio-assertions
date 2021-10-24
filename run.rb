require 'nokogiri'

PROJECT_PATH = 'contract_variants'

ORIGINAL_ECF = "#{PROJECT_PATH}/contract_variants.ecf"

ALL_TAGS = Dir.glob('./**/*.e')
  .sort_by(&:length)
  .flat_map { |f| File.readlines(f) }
  .flat_map { |line| line.scan(/(\w+):/) }
  .flatten
  .uniq - %w[
    i
    demo
    satisfy
    satisfy_invariant
    other_cluster_demo
    other_library_demo
    indirect_cluster_demo
    subcluster_demo
  ]

ASSERTIONS = %i[
  precondition
  postcondition
  check
  invariant
  loop
  supplier_precondition
].freeze

# Direct child of node, created if absent
def child(node, name)
  result = node.at_xpath("./xmlns:#{name}")
  result = node.add_child("<#{name}>").first unless result

  result
end

# Set Assertions setting for the XML node,
# creating the <assertions> node if not present
def set_assertions(node, settings)
  option = child(node, 'option')
  assertions = child(option, 'assertions')

  settings.each do |setting, value|
    assertions[setting.to_s] = value.to_s
  end
end

def all_disabled
  ASSERTIONS.to_h { |x| [x, false] }
end

results = {}

combinations = {}
combinations['All'] = ASSERTIONS
combinations['Require'] = [:precondition]
combinations['Ensure'] = [:postcondition]
combinations['Check'] = [:check]
combinations['Invariant'] = [:invariant]
combinations['Loop'] = [:loop]
combinations['Supplier Precondition'] = [:supplier_precondition]

combinations.each do |name, enabled_assertions|
  $stderr.puts "=" * 8
  $stderr.puts name
  $stderr.puts "=" * 8

  doc = File.open(ORIGINAL_ECF) { |f| Nokogiri::XML(f) }

  other_library = doc.at_xpath('//xmlns:library[@name="other_library"]')
  all_clusters = doc.xpath('//xmlns:cluster')
  main_cluster = doc.at_xpath('//xmlns:cluster[@name="main"]')

  [other_library, *all_clusters].each do |node|
    set_assertions(node, all_disabled)
  end

  settings = enabled_assertions.to_h { |a| [a, true] }
  set_assertions(main_cluster, settings)

  ecf_name = "#{PROJECT_PATH}/check_#{name.downcase.gsub(' ', '_')}.ecf"

  File.write(ecf_name, doc.to_xml)

  # Compile
  res = system <<-CMD.gsub("\n", ' ')
      ec
        -project_path "#{PROJECT_PATH}"
        -config #{ecf_name}
        -clean
        -c_compile
        >&2
  CMD

  # Run
  out = `./#{PROJECT_PATH}/EIFGENs/contract_variants/W_code/contract_variants`

  # Save results
  results[name] = out.strip.split("\n")
end


# Print markdown table
lines = []

pretty_tags = ALL_TAGS.map do |tag|
  tag = tag.delete_suffix('_')

  next tag if tag.include?('loop')

  i = tag.rindex('_')
  tag[i] = ' ' if i

  tag
end

header = ['', *pretty_tags]
lines << '|' + header.join('|') + '|'
lines << '|---|' + ([':---:'] * (header.count - 1)).join('|') + '|'

results.each do |assertion, tags|
  row = [assertion]
  ALL_TAGS.each do |tag|
    row << (tags.include?(tag) ? 'X' : ' ')
  end

  lines << '|' + row.join('|') + '|'

  unexpected = tags - ALL_TAGS
  raise "Unexpected program outputs #{unexpected}, supported #{ALL_TAGS}" unless unexpected.empty?
end

puts lines.join("\n")
