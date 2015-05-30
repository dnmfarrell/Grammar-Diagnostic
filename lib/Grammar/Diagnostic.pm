class Grammar::Diagnostic:ver<0.01>
{
  # this array tracks matching start/end match object pairs like =over & =back
  has @.match_pair_stack = Array.new;

  method push_match (Match:D $match)
  {
    @.match_pair_stack.push($match);
  }

  method pop_match ()
  {
    @.match_pair_stack.pop;
  }

  # retuns a list of unmatched pair diagnosis msgs
  method unmatched_diagnostics ()
  {
    my @unmatched = Array.new;

    for @.match_pair_stack -> $match
    {
      my $location = self.match_location($match);
      @unmatched.push("Did not find matching token for '{$match.Str}' line {$location<line>}, column {$location<column>}");
    }

    return @unmatched;
  }

  method print_diagnostics ()
  {
    .say for self.unmatched_diagnostics;
  }

  # translates match object to/from into line # and column #
  method match_location (Match:D $match)
  {
    my $substring = $match.orig.substr(0, $match.from);
    my @lines = $substring.split(/\n/);
    return { line => @lines.elems, column => @lines[*-1].chars };
  }
}

