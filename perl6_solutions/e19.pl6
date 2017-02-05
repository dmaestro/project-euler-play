# You are given the following information, but you may prefer to do some research for yourself.
#
#   1 Jan 1900 was a Monday.
#   Thirty days has September,
#   April, June and November.
#   All the rest have thirty-one,
#   Saving February alone,
#   Which has twenty-eight, rain or shine.
#   And on leap years, twenty-nine.
#   A leap year occurs on any year evenly divisible by 4, but not on a century unless it is divisible by 400.
#
# How many Sundays fell on the first of the month during the twentieth century (1 Jan 1901 to 31 Dec 2000)?

enum DayName «
    :Monday(1)
    Tuesday
    Wednesday
    Thursday
    Friday
    Saturday
    Sunday
»;

my $century-c20th-start = Date.new: '1901-01-01';
my $century-c20th-end   = Date.new: '2000-12-31';

# say $century-c20th-start.later(:1day);

# say ($century-c20th-start .. $century-c20th-end).elems;


sub MAIN(Str :$start = '1901-01-01', Str :$end = '2000-12-31') {
    my $start-date = Date.new($start);
    my $end-date   = Date.new($end);
    my ($first-sunday) = (^7)».&{ $start-date.later( :day($_) ) }.grep: { .day-of-week == Sunday };
    say ( $first-sunday, { .later(:7day) } ...^ * > $end-date ).grep( { .day == 1 } ).elems;
}
