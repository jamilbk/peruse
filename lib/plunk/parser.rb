require 'parslet'

class Plunk::Parser < Parslet::Parser
  # Single character rules
  rule(:lparen)     { str('(') >> space? }
  rule(:rparen)     { str(')') >> space? }
  rule(:comma)      { str(',') >> space? }
  rule(:digit)      { match('[0-9]') }
  rule(:space)      { match('\s').repeat(1) }
  rule(:space?)     { space.maybe }

  # Numbers
  rule(:integer)    { str('-').maybe >> digit.repeat(1) >> space? }
  rule(:float)      {
    str('-').maybe >> digit.repeat(1) >> str('.') >> digit.repeat(1) >> space?
  }
  rule(:number)     { integer | float }

  # Field / value
  rule(:identifier) { match['_@a-zA-Z.'].repeat(1) }
  rule(:wildcard)   { match('[a-zA-Z0-9.*]').repeat(1) }
  rule(:searchop)   { match('[=]').as(:op) >> space? }

  # boolean operators search
  rule(:concatop)   { (str('OR') | str('AND')) >> space? }
  rule(:operator)   { match('[|]').as(:op) >> space? }
  rule(:timerange)  {
    integer.as(:quantity) >> match('s|m|h|d|w').as(:quantifier)
  }

  # Grammar parts
  rule(:rhs) {
      (regex | wildcard | integer | subsearch |
        (lparen >> (space? >> (wildcard | integer) >>
          (space >> concatop).maybe).repeat(1) >> rparen))
  }

  rule(:regex) {
    str('/') >> match('[^/]').repeat >> str('/')
  }

  rule(:search) {
    identifier.as(:field) >> space? >> searchop >> space? >>
      rhs.as(:value) | rhs.as(:match)
  }

  rule(:last) {
    str("last") >> space >> timerange.as(:timerange) >> space >>
    search.as(:search)
  }

  rule(:binaryop) {
    (paren | search).as(:left) >> space? >> operator >> job.as(:right)
  }

  rule(:subsearch) {
    str('`') >> space? >> nested_search >> str('`')
  }

  rule(:nested_search) {
    match('[^|]').repeat.as(:term) >> str('|') >> space? >>
    match('[^`]').repeat.as(:extractors)
  }

  rule(:joined_search) {
    
  }

  rule(:paren) {
    lparen >> space? >> job >> space? >> rparen
  }

  rule(:job) {
    binaryop | paren | last | search
  }

  # root :job
  rule(:plunk_query) {
    job >> (space >> job).repeat
  }

  root :plunk_query
end

