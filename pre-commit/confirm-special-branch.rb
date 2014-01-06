#!/usr/bin/env ruby
# -*- coding: utf-8 -*-

# 確認するブランチ名
SPECIAL_BRANCHES = %w( master staging )

current_branch = `git rev-parse --abbrev-ref HEAD`.chomp

if SPECIAL_BRANCHES.include?(current_branch)
  $stdin.reopen('/dev/tty')
  print "commit to `#{current_branch}` branch? [Y/n] : "
  exit(false) unless gets[0] =~ /Y|y/
end

exit(true)
