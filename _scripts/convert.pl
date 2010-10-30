#!/usr/bin/env perl -wT
use strict;
use warnings;
use FileHandle;
use DateTime;
use DateTime::Format::Strptime;

no strict 'refs';

my $file = FileHandle->new('< export.txt');

if (defined $file) {
  my $defaults = {
    category => 'OffTopic', 
    tags => []
  };
  my $post = {%{$defaults}};

  while (my $line = $file->getline()) {
    if ($line =~ /^TITLE: (.*)$/) {
      $post->{title} = $1;
    }; 

    if ($line =~ /^BASENAME: (.*)$/) {
      my $slug = lc $1;
      $slug =~ s/_/-/g;
      $post->{slug} = $slug; 
    };

    if ($line =~ /^PRIMARY CATEGORY: (.*)$/) {
      my $category = $1;
      $category =~ s/\?//g;

      $post->{category} = $category;
    };

    if ($line =~ /^TAGS: (.*)$/) {
      my $tags = lc $1;
      my @tags = split(/,\s*/, $tags);

      for (@tags) {
        s/\"//g; 
      };

      $post->{tags} = \@tags;
    };

    if ($line =~/^COMMENT:$/) {
      $post->{incomments} = 1;    
    };

    if ($line =~ /^DATE: (.*)$/) {
      if (! $post->{incomments}) {
      
        my $format = DateTime::Format::Strptime->new(
          pattern => '%m/%d/%Y %l:%M:%S %p',
          time_zone => "America/New_York"
        );
        my $date = $format->parse_datetime($1);
        my $day = $date->ymd;
        my $slug = $post->{slug};
        my $filename = "$day-$slug.textile";

        $post->{date} = $date;    
        $post->{filename} = $filename;
      }
    };

    if ($line =~ /^BODY:$/) {
      my $bline = $file->getline;

      until ($bline =~ /^-----$/) {
        $post->{body} .= $bline;

        $bline = $file->getline; 
      };
    };

    if ($line =~ /^EXTENDED BODY:$/) {
      my $bline = $file->getline;

      until ($bline =~ /^-----$/) {
        $post->{extended} .= $bline;

        $bline = $file->getline; 
      };
    };

    if ($line =~ /^--------$/) {
      writePost($post);
      $post = {};
      $post = {%{$defaults}};
    }
  };
  $file->close;
};

sub writePost() {
  my $post = shift;
  my $filename = '../_posts/' . $post->{filename};
  my $file = FileHandle->new("> $filename");
  my @tags = @{$post->{tags}};

  my $title = $post->{title};
  $title =~ s/"/\\"/g;

  my $body = $post->{body};
  $body =~ s/blog\/images/images/g;
  $body =~ s/http\:\/\/today\.icantfocus\.com\/blog//g;
  $body =~ s/http\:\/\/today\.icantfocus\.com//g;
  $body =~ s/\/assets_c/\/images\/assets_c/g;
  
  my $extended = $post->{extended};
  $extended =~ s/blog\/images/images/g;
  $extended =~ s/http\:\/\/today\.icantfocus\.com\/blog//g;
  $extended =~ s/http\:\/\/today\.icantfocus\.com//g;
  $extended =~ s/\/assets_c/\/images\/assets_c/g;

  $file->print("---", "\n");
  $file->print("layout: post", "\n");
  $file->print("title: \"", $title, "\"\n");
  $file->print("slug: ", $post->{slug}, "\n");
  $file->print("category: ", $post->{category}, "\n");
  if (scalar @tags) {
    $file->print("tags:\n  - ", join('  - ', map{$_ . "\n"} @tags));
  };
  $file->print("published:\n");
  $file->print("  epoch: ", $post->{date}->epoch, "\n");
  $file->print("  utc: ", $post->{date}->set_time_zone('UTC')->datetime, "\n");
  $file->print("---", "\n\n");
  $file->print($body);
  $file->print($extended, "\n");

  $file->close;
  utime $post->{date}->epoch, $post->{date}->epoch, $filename;
};
