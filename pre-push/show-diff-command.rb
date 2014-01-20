#!/usr/bin/env ruby
# -*- coding: utf-8 -*-

remote_name, remote_url = ARGV

ref_infos = $stdin.gets
exit(true) if ref_infos.nil?

local_ref, local_sha1, remote_ref, remote_sha1 = ref_infos.chomp.split(' ')

PREFIX = '[diff-command]'
ABBREV = 7

remote_ref =~ %r|refs/heads/(.+)|
remote_branch_name = $1 ? [remote_name, $1].join('/') : nil

### この branch がどこから切られたか heuristics に見つける
current_branch = `git rev-parse --abbrev-ref HEAD`
# このブランチにしか含まれない commit の中で最初のものを見つける
current_branch_first_commit = `git rev-list --all --not $(git rev-list --all ^#{current_branch}) | tail -n 1`.chomp

unless current_branch_first_commit.empty?
  # 大抵 local branch から切るはずだし -r は遅くなるからつけないでおく
  candidate_branches =
    `git branch --contains $(git rev-parse #{current_branch_first_commit}^) | sed 's/^[* ] //'`.split("\n")

  # remote に名前があって一番短い名前の branch 名を探す
  remote_name = nil
  candidate_branches.sort_by{ |name| name.length }.each{ |br|
    remote_name = `git rev-parse --abbrev-ref #{br}@{upstream} 2>/dev/null`.chomp
    break if $?.success?
  }
  puts "#{PREFIX} git diff #{remote_name}...#{remote_branch_name}" if remote_name
end

# 既に remote に tracking している branch があればそこからの差分を出す
unless remote_sha1 =~ /^0+$/
  puts "#{PREFIX} git diff #{remote_sha1[0..ABBREV]} #{local_sha1[0..ABBREV]}"
end
