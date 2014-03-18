require 'parslet'

module Plunk
  class Parser < Parslet::Parser

    # Single character rules
    rule(:lparen)     { str('(') >> space? }
    rule(:rparen)     { str(')') >> space? }
    rule(:digit)      { match('[0-9]') }
    rule(:space)      { match('\s').repeat(1) }
    rule(:space?)     { space.maybe }

    rule(:and_operator) { (str("and") | str("AND")) >> space? }
    rule(:or_operator)  { (str("or") | str("OR"))  >> space? }
    rule(:not_operator) { (str("not") | str("NOT")) >> space? }

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
    rule(:negate)   { (str('NOT') | str('not')) >> space? }







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
      (value_only | field_value).as(:command) >> space?
      # (str('command') >> digit).as(:command) >> space?
    }


    rule(:primary) { lparen >> or_operation >> rparen | command }

    rule(:and_operation) { 
      (primary.as(:left) >> and_operator >> 
        ((not_operator >> and_operation.as(:not)) | and_operation).as(:right)).as(:and) | 
      primary }
      
    rule(:or_operation)  { 
      (and_operation.as(:left) >> or_operator >> 
        ((not_operator >> or_operation.as(:not)) | or_operation).as(:right)).as(:or) | 
      and_operation }

    root(:or_operation)
  end
end
