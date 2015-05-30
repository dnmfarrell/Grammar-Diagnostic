use Test;
use lib 'lib';

plan 4;

use Grammar::Diagnostic; pass "Import Grammar::Diagnostic";

ok my $diag = Grammar::Diagnostic.new, 'constructor';

subtest
{
  my $input_string = "Perl 6\nis a new language\nfor doing\ncool things";
  my $match = $input_string.match(/(doing)/);

  # match location
  ok my $match_location = $diag.match_location($match), 'get match location';
  is $match_location<line>,   3, 'match location line number is correct';
  is $match_location<column>, 4, 'match location column number is correct';

  # match_text
  is $match.Str, 'doing', 'match text matches expected';
}, 'Match location and text';

subtest
{
  my $input_string = q:to/END/;
  =begin

  some text

  =begin

  some more text

  =end
  END

  my $match = $input_string.match(/(^^\=begin)/);

  ok $diag.push_match($match), 'push the match onto the stack';
  $diag.print_diagnostics;
}, 'Match pairs and diagnostics';
