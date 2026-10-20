#!/usr/bin/env bash
# 推送本仓库到 GitHub。账号恢复后直接跑：
#   GITHUB_TOKEN=<你的 PAT> ./push.sh            # 仓库不存在时自动创建（private）
#   GITHUB_TOKEN=<你的 PAT> ./push.sh --public   # 公开
# 也接受环境变量 DSH_SECRET_GITHUB_MIRROR_TOKEN。
set -euo pipefail
OWNER="${OWNER:-OnlyCopi}"
REPO="${REPO:-dsh-infinite-gen-one}"
TOKEN="${GITHUB_TOKEN:-${DSH_SECRET_GITHUB_MIRROR_TOKEN:-}}"
VISIBILITY="private"
[[ "${1:-}" == "--public" ]] && VISIBILITY="public"

if [[ -z "$TOKEN" ]]; then
  echo "缺少 token：export GITHUB_TOKEN=... 后重试" >&2
  exit 1
fi

me=$(curl -s -o /tmp/_u.json -w '%{http_code}' -H "Authorization: Bearer $TOKEN" https://api.github.com/user)
if [[ "$me" != "200" ]]; then
  echo "token 不可用（HTTP $me）："; head -c 200 /tmp/_u.json; echo
  exit 1
fi
login=$(python3 -c 'import json;print(json.load(open("/tmp/_u.json"))["login"])')
echo "token 属于: $login"

code=$(curl -s -o /dev/null -w '%{http_code}' -H "Authorization: Bearer $TOKEN" "https://api.github.com/repos/$OWNER/$REPO")
if [[ "$code" == "404" ]]; then
  echo "创建仓库 $OWNER/$REPO ($VISIBILITY)"
  curl -s -X POST -H "Authorization: Bearer $TOKEN" -H 'Accept: application/vnd.github+json' \
    https://api.github.com/user/repos \
    -d "{\"name\":\"$REPO\",\"private\":$([[ $VISIBILITY == private ]] && echo true || echo false),\"description\":\"dsh-infinite-gen-one: prompt-layering plugin for DeepSeek Harness (fork of dsh-infinite-gen-2, MIT)\"}" \
    -o /tmp/_c.json -w '%{http_code}\n'
  head -c 300 /tmp/_c.json; echo
elif [[ "$code" == "200" ]]; then
  echo "仓库已存在，直接推送"
else
  echo "查询仓库失败 HTTP $code"; exit 1
fi

git remote remove origin 2>/dev/null || true
git remote add origin "https://x-access-token:$TOKEN@github.com/$OWNER/$REPO.git"
git push -u origin HEAD:main
git push origin --tags 2>/dev/null || true
echo "完成：https://github.com/$OWNER/$REPO"
