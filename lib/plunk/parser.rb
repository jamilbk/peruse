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
    rule(:identifier) { match('[^=\s)(|]').repeat(1) >> match('[^=\s]').repeat }
    # possible right-hand side values
    rule(:wildcard)   { match('[^=\s)(|]').repeat(1) }
    rule(:searchop)   { match['='].as(:op) }

    rule(:query_value) { string | wildcard | datetime | number }

    # boolean operators search
    rule(:concatop)   { (str('OR') | str('AND')) >> space? }
    rule(:negateop)   { str('NOT') >> space? }
    rule(:operator)   { match('[|]').as(:op) >> space? }
    rule(:timerange)  {
      integer.as(:quantity) >> match('s|m|h|d|w').as(:quantifier)
    }

    # Grammar parts
    rule(:rhs) {
      regexp | subsearch | booleanop
    }

    rule(:boolean_value) {
      booleanparen | field_value | (negateop.maybe >> query_value)
    }

    rule(:field_value) {
      identifier >> space? >> searchop >> space? >> query_value
    }

    # AND, OR
    rule(:boolean_logic) {
      space >> concatop >> boolean_value
    }

    # handles recursion for parentheses and values
    rule(:booleanop) {
      boolean_value >> boolean_logic.repeat
    }
    rule(:booleanparen) {
      lparen >> space? >> booleanop >> space? >> rparen
    }

    rule(:regexp) {
      str('/') >> (str('\/') | match('[^/]')).repeat >> str('/')
    }

    rule(:last) {
      str("last") >> space >> timerange.as(:timerange) >> (space >>
      search.as(:search)).maybe
    }

    rule(:search) {
      identifier.as(:field) >> space? >> searchop >> space? >>
        rhs.as(:value) | rhs.as(:match)
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
      paren | last | search
    }

    rule(:plunk_query) {
      job >> (space >> (concatop.maybe) >> job).repeat
    }

    root :plunk_query
  end
end
