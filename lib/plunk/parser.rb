require 'parslet'

module Plunk
  class Parser < Parslet::Parser

    # Single character rules
    rule(:lparen)     { str('(') }
    rule(:rparen)     { str(')') }
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

    # Strings
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

    # Booleans
    rule(:and_or)   { (str('OR') | str('AND') | str('or') | str('and')) }
    rule(:negate)   { str('NOT') | str('not') }







    # COMMANDS

    # field = value
    rule(:field_value) {
      identifier.as(:field) >> space? >>
      searchop.as(:op) >> space? >>
      (rhs.as(:value) | subsearch.as(:subsearch))
    }
    rule(:searchop)   { match['='] }
    rule(:rhs) {
      regexp | query_value
    }
    rule(:identifier) { match('[^=\s)(|]').repeat(1) >> match('[^=\s]').repeat }
    rule(:wildcard)   { match('[^=\s)(|]').repeat(1) }
    rule(:query_value) { string | wildcard | datetime | number }
    # Strings


    # Value-only
    rule(:value_only) {
      rhs.as(:value)
    }

    # Regexp
    rule(:regexp) {
      str('/') >> (str('\/') | match('[^/]')).repeat >> str('/')
    }

    # Last
    rule(:last) {
      str("last") >> space >> timerange.as(:timerange)
    }
    rule(:timerange)  {
      integer.as(:quantity) >> match('s|m|h|d|w').as(:quantifier)
    }

    # Subsearch
    rule(:subsearch) {
      str('`') >> space? >> nested_search >> str('`')
    }
    rule(:nested_search) {
      plunk_query.as(:initial_query) >> space? >> str('|') >> space? >>
      match('[^`]').repeat.as(:extractors)
    }

    rule(:command) {
      # value_only | field_value
      str('command') >> digit
    }







    # COMMAND JOINING
    rule(:boolean_value) {
      booleanparen |
      command.as(:command) |
      ((negate >> space).maybe.as(:not) >> booleanop)
    }
    rule(:boolean_logic) {
      space >> and_or.as(:and_or) >> space >> boolean_value
    }
    rule(:booleanop) {
      boolean_value >> boolean_logic.as(:logic).repeat
    }
    rule(:booleanparen) {
      lparen >> space? >> booleanop >> space? >> rparen
    }
    rule(:plunk_query) {
      booleanop
    }

    root :plunk_query
  end
end
