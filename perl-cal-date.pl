#!/usr/bin/perl
use 5.012;
use strict;

# You are given the following information, but you may prefer to do some research for yourself.

# 1 Jan 1900 was a Monday.
# Thirty days has September,
# April, June and November.
# All the rest have thirty-one,
# Saving February alone,
# Which has twenty-eight, rain or shine.
# And on leap years, twenty-nine.
# A leap year occurs on any year evenly divisible by 4, but not on a century unless it is divisible by 400.
# How many Sundays fell on the first of the month during the twentieth century (1 Jan 1901 to 31 Dec 2000)?

my @month_days = (31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31);
my @week = ("mon", "tue", "wed", "thu", "fri", "sat", "sun");

say cal_two_date(@ARGV);

sub is_leap_year {
  my $year = shift;
  if($year % 100 != 0 and $year % 4 == 0){
    return 1;
  }
  if($year % 400 == 0){
    return 1;
  }
  return 0;
}

sub get_whole_year_days{
  my $ret = 0;
  my $year = shift;
  foreach (@month_days){
    $ret += $_;
  }
  if(is_leap_year($year)){
    $ret += 1;
  }
  return $ret;
}

sub get_whole_month_days{
  my $year = shift;
  my $month = shift;
  my $ret;
  if(is_leap_year($year) && $month == 2){
    return @month_days[$month - 1] + 1;
  }
  return @month_days[$month - 1];
}

sub get_till_month_begin_days{
  my $year = shift;
  my $month = shift;
  my $day = shift;
  return $day;              # muse be yestoday(totaly wrong!!!)
}

sub get_till_year_begin_days{
  my $year = shift;
  my $month = shift;
  my $day = shift;
  my $ret = 0;
  for(1..($month - 1)){
    $ret += get_whole_month_days($year, $_);
  }
  return $ret + get_till_month_begin_days($year, $month, $day);
}

sub get_till_month_end_days{
  my $year = shift;
  my $month = shift;
  my $day = shift;
  if(is_leap_year($year) && $month == 2){
    return @month_days[$month - 1] + 1 - $day;
  }
  return @month_days[$month - 1] - $day;
}

sub get_till_year_end_days{
  my $year = shift;
  my $month = shift;
  my $day = shift;
  my $ret = 0;
  $ret += get_till_month_end_days($year, $month, $day);
  for(($month + 1)..12){
    $ret += get_whole_month_days($year, $_);
  }
  return $ret;
}

sub _cal_two_date_non_same_year{
  my ($y, $m, $d, $y_b, $m_b, $d_b) = @_;
  my $ret = 0;
  for(($y + 1)..($y_b - 1)){
    $ret += get_whole_year_days($_);
  }
  return $ret + get_till_year_end_days($y, $m, $d) + get_till_year_begin_days($y_b, $m_b, $d_b);
}

sub _cal_two_date_same_year{
  my ($y, $m, $d, $y_b, $m_b, $d_b) = @_;
  my $year_days = is_leap_year($y) ? 366 : 365;
  my $end = get_till_year_end_days($y, $m, $d);
  my $begin = get_till_year_begin_days($y_b, $m_b, $d_b);
  return $begin + $end - $year_days;
}

sub cal_two_date {
  #my ($y, $m, $d, $y_b, $m_b, $d_b) = @_;
  # check args suspend...
  # check which is bigger
  my ($y, $m, $d, $y_b, $m_b, $d_b) = @_;
  if($y == $y_b){
    return _cal_two_date_same_year(@_);
  }
  else{
    return _cal_two_date_non_same_year(@_);
  }
}

sub check_sundays{
  my $ret = 0;
  my ($y, $m, $d, $y_b, $m_b, $d_b) = @_;
  for($y..$y_b){
    my $temp_year = $_;
    for(1..12){
      if(cal_two_date($y, $m, $d, $temp_year, $_, 1) % 7 == 5){
        $ret += 1;
      }
    }
  }
  return $ret;
}
