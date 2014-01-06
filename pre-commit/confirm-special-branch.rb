#!/usr/bin/env ruby
# -*- coding: utf-8 -*-

# 確認するブランチ名
SPECIAL_BRANCHES = %w( master staging )

# 何も add されてない時は素通りさせる
exit(true) if `git diff --name-only --cached`.empty?


current_branch = `git rev-parse --abbrev-ref HEAD`.chomp

if SPECIAL_BRANCHES.include?(current_branch)
  $stdin.reopen('/dev/tty')
  print "commit to `#{current_branch}` branch? [Y/n] : "
  exit(false) unless gets[0] =~ /Y|y/
end

exit(true)
