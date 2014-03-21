require 'parslet'

module Plunk
  class Parser < Parslet::Parser

    # BUILDING BLOCKS

    # Single character rules
    rule(:lparen)     { str('(') >> space? }
    rule(:rparen)     { str(')') >> space? }
    rule(:digit)      { match('[0-9]') }
    rule(:space)      { match('\s').repeat(1) }
    rule(:space?)     { space.maybe }

    # Numbers
    rule(:positive_integer) { digit.repeat(1) >> space? }
    rule(:negative_integer) { str('-') >> positive_integer }
    rule(:integer)    { negative_integer | positive_integer }
    rule(:float)      {
      str('-').maybe >> digit.repeat(1) >> str('.') >> digit.repeat(1) >> space?
    }
    rule(:number)     { integer | float }

    # Dates
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
    rule(:and_operator) { (str('and') | str('AND') | str('&')) >> space? }
    rule(:or_operator)  { (str('or') | str('OR') | str('|'))  >> space? }
    rule(:not_operator) { (str('not') | str('NOT') | str('~')) >> space? }


    # COMMANDS

    # Command parts
    rule(:identifier) { match('[^=\s)(|]').repeat(1) >> match('[^=\s]').repeat }
    rule(:wildcard)   {
      (lparen >> wildcard >> rparen) |
      match('[^=\s|)(]').repeat(1)
    }
    rule(:query_value) { string | wildcard | datetime | number }
    rule(:searchop)   { match['='] }
    rule(:rhs) {
      regexp | query_value
    }
    rule(:chronic_time) {
      string | match('[^\s]').repeat
    }
    rule(:relative_time) {
      integer.as(:quantity) >>
      match('s|m|h|d|w').as(:quantifier)
    }
    rule(:absolute_time) {
      datetime.as(:datetime) | chronic_time.as(:chronic_time)
    }

    # Field = Value
    rule(:field_value) {
      identifier.as(:field) >> space? >>
      searchop >> space? >>
      (rhs.as(:value) | subsearch.as(:subsearch))
    }

    # Value-only
    rule(:value_only) {
      query_value.as(:value)
    }

    # Window
    rule(:window) {
      str('window') >>
      space >>
      (relative_time | absolute_time).as(:window_start) >>
      space >> str('to') >> space >>
      (relative_time | absolute_time).as(:window_end)
    }

    # Limit
    rule(:limit) {
      str('limit') >> space >> positive_integer.as(:limit)
    }

    # Regexp
    rule(:regexp) {
      str('/') >> (str('\/') | match('[^/]')).repeat.as(:regexp) >> str('/')
    }

    # Last
    rule(:last) {
      (str('last') >> space >> relative_time).as(:last)
    }

    # Subsearch
    rule(:subsearch) {
      str('`') >> space? >> nested_search >> str('`')
    }
    rule(:nested_search) {
      plunk_query.as(:initial_query) >> space? >> str('|') >> space? >>
      match('[^`]').repeat.as(:extractors)
    }

    # Reference your custom commands here to make them eligible for parsing
    # NOTE: order matters!
    rule(:command) {
      (
        window      |
        last        |
        limit       |
        field_value |
        value_only
      ).as(:command) >> space?
    }


    # QUERY JOINING
 
    rule(:negated_command) {
      (not_operator >> command.as(:not)) |
      command
    }
    rule(:primary) { lparen >> or_operation >> rparen | negated_command }

    rule(:negated_and) {
      (not_operator >> and_operation.as(:not)) |
      and_operation
    }
    rule(:and_operation) { 
      (primary.as(:left) >> and_operator >> 
        negated_and.as(:right)).as(:and) | 
      primary }
      
    rule(:negated_or) {
      (not_operator >> or_operation.as(:not)) |
      or_operation
    }
    rule(:or_operation)  { 
      (and_operation.as(:left) >> or_operator >> 
        negated_or.as(:right)).as(:or) | 
      and_operation }

    rule(:plunk_query) {
      space? >> or_operation >> space?
    }

    root(:plunk_query)
  end
end
