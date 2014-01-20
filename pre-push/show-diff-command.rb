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

### この branch がどこから切られたか heuristics に探す
current_branch = `git rev-parse --abbrev-ref HEAD`
# reflog から探す、レビュー依頼するのは自分で切った branch のはずなので見つかると思うな〜
created_commit = `git reflog #{current_branch} | grep Created | tail -n 1 | cut -d' ' -f1`.chomp

unless created_commit.empty?
  # 大抵 local から切るはずだし -r は遅くなるのでつけないでおくね
  candidate_branches =
    `git branch --contains #{created_commit} | sed 's/^[* ] //' | grep -vE '^#{current_branch}$'`.split("\n")

  # remote に名前があって一番短い名前の branch 名を探すよ
  remote_name = ''
  candidate_branches.sort_by{ |name| name.length }.each{ |br|
    remote_name = `git rev-parse --abbrev-ref #{br}@{upstream} 2>/dev/null`.chomp
    break if $?.success?
  }

  puts "#{PREFIX} git diff #{remote_name}...origin/#{current_branch}" unless remote_name.empty?
end

# push 先で新規の branch でなければ前回の upstream との差分も表示する
unless remote_sha1 =~ /^0+$/
  puts "#{PREFIX} git diff #{remote_sha1[0..ABBREV]} #{local_sha1[0..ABBREV]}"
end
