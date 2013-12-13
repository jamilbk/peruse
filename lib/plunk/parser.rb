require 'parslet'

module Plunk
  class Parser < Parslet::Parser

    def parenthesized(atom)
      lparen >> atom >> rparen
    end

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
    rule(:datetime) {
        # 1979-05-27T07:32:00Z
      digit.repeat(4) >> str("-") >> 
      digit.repeat(2) >> str("-") >> 
      digit.repeat(2) >> str("T") >> 
      digit.repeat(2) >> str(":") >> 
      digit.repeat(2) >> str(":") >> 
      digit.repeat(2) >> str("Z")
    }
    rule(:escaped_special) {
      str("\\") >> match['0tnr"\\\\']
    }

    rule(:string_special) {
      match['\0\t\n\r"\\\\']
    }
    rule(:string) {
      str('"') >>
      (escaped_special | string_special.absent? >> any).repeat >>
      str('"')
    }

    # Field / value
    # rule(:identifier) { match['_@a-zA-Z.'].repeat(1) }
    rule(:identifier) { match('[^=\s]').repeat(1) }
    rule(:wildcard)   { match('[a-zA-Z0-9.*]').repeat(1) }
    rule(:searchop)   { match('[=]').as(:op) }
    rule(:query_value) { number | string | datetime | wildcard }

    # boolean operators search
    rule(:concatop)   { (str('OR') | str('AND')) >> space? }
    rule(:operator)   { match('[|]').as(:op) >> space? }
    rule(:timerange)  {
      integer.as(:quantity) >> match('s|m|h|d|w').as(:quantifier)
    }

    # Grammar parts
    rule(:rhs) {
      regexp | subsearch | booleanop
      # regexp | subsearch | integer | wildcard | booleanop
    }

    rule(:boolean_value) {
      booleanparen | query_value
    }

    rule(:booleanop) {
      boolean_value >> (space >> concatop >> boolean_value).repeat
    }

    rule(:booleanparen) {
      lparen >> space? >> booleanop >> space? >> rparen
    }

    rule(:regexp) {
      str('/') >> match('[^/]').repeat >> str('/')
    }

    rule(:last) {
      str("last") >> space >> timerange.as(:timerange) >> (space >>
      search.as(:search)).maybe
    }

    rule(:search) {
      identifier.as(:field) >> space? >> searchop >> space? >>
        rhs.as(:value) | rhs.as(:match)
    }

    rule(:binaryop) {
      (search | paren).as(:left) >> space? >> operator >> job.as(:right)
    }

    rule(:subsearch) {
      str('`') >> space? >> nested_search >> str('`')
    }

    rule(:nested_search) {
      job.as(:initial_query) >> space? >> str('|') >> space? >>
      match('[^`]').repeat.as(:extractors)
    }

    rule(:paren) {
      lparen >> space? >> job >> space? >> rparen
    }

    rule(:job) {
      last | search | binaryop | paren
    }

    # root :job
    rule(:plunk_query) {
      job >> (space >> job).repeat
    }

    root :plunk_query
  end
end
