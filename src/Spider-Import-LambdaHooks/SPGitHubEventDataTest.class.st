Class {
	#name : #SPGitHubEventDataTest,
	#superclass : #TestCase,
	#category : #'Spider-Import-LambdaHooks'
}

{ #category : #'as yet unclassified' }
SPGitHubEventDataTest >> demoEvent [

	^ 'push'
]

{ #category : #'as yet unclassified' }
SPGitHubEventDataTest >> demoGuid [

	^ '3861a1c0-1fe4-11ea-8408-6d83f3993182'
]

{ #category : #'as yet unclassified' }
SPGitHubEventDataTest >> demoPayload [

	^'{
  "ref": "refs/heads/master",
  "before": "285923417a54784c83f5ac2312c6b0a049c52897",
  "after": "db416c48d24402035d2e4f7a48db8ae4621a630f",
  "repository": {
    "id": 88487459,
    "node_id": "MDEwOlJlcG9zaXRvcnk4ODQ4NzQ1OQ==",
    "name": "jvds-sudoku-model-kotlin",
    "full_name": "jvdsandt/jvds-sudoku-model-kotlin",
    "private": false,
    "owner": {
      "name": "jvdsandt",
      "email": "jvdsandt@gmail.com",
      "login": "jvdsandt",
      "id": 161266,
      "node_id": "MDQ6VXNlcjE2MTI2Ng==",
      "avatar_url": "https://avatars1.githubusercontent.com/u/161266?v=4",
      "gravatar_id": "",
      "url": "https://api.github.com/users/jvdsandt",
      "html_url": "https://github.com/jvdsandt",
      "followers_url": "https://api.github.com/users/jvdsandt/followers",
      "following_url": "https://api.github.com/users/jvdsandt/following{/other_user}",
      "gists_url": "https://api.github.com/users/jvdsandt/gists{/gist_id}",
      "starred_url": "https://api.github.com/users/jvdsandt/starred{/owner}{/repo}",
      "subscriptions_url": "https://api.github.com/users/jvdsandt/subscriptions",
      "organizations_url": "https://api.github.com/users/jvdsandt/orgs",
      "repos_url": "https://api.github.com/users/jvdsandt/repos",
      "events_url": "https://api.github.com/users/jvdsandt/events{/privacy}",
      "received_events_url": "https://api.github.com/users/jvdsandt/received_events",
      "type": "User",
      "site_admin": false
    },
    "html_url": "https://github.com/jvdsandt/jvds-sudoku-model-kotlin",
    "description": "Kotlin port of the Sudoku programming language experiments",
    "fork": false,
    "url": "https://github.com/jvdsandt/jvds-sudoku-model-kotlin",
    "forks_url": "https://api.github.com/repos/jvdsandt/jvds-sudoku-model-kotlin/forks",
    "keys_url": "https://api.github.com/repos/jvdsandt/jvds-sudoku-model-kotlin/keys{/key_id}",
    "collaborators_url": "https://api.github.com/repos/jvdsandt/jvds-sudoku-model-kotlin/collaborators{/collaborator}",
    "teams_url": "https://api.github.com/repos/jvdsandt/jvds-sudoku-model-kotlin/teams",
    "hooks_url": "https://api.github.com/repos/jvdsandt/jvds-sudoku-model-kotlin/hooks",
    "issue_events_url": "https://api.github.com/repos/jvdsandt/jvds-sudoku-model-kotlin/issues/events{/number}",
    "events_url": "https://api.github.com/repos/jvdsandt/jvds-sudoku-model-kotlin/events",
    "assignees_url": "https://api.github.com/repos/jvdsandt/jvds-sudoku-model-kotlin/assignees{/user}",
    "branches_url": "https://api.github.com/repos/jvdsandt/jvds-sudoku-model-kotlin/branches{/branch}",
    "tags_url": "https://api.github.com/repos/jvdsandt/jvds-sudoku-model-kotlin/tags",
    "blobs_url": "https://api.github.com/repos/jvdsandt/jvds-sudoku-model-kotlin/git/blobs{/sha}",
    "git_tags_url": "https://api.github.com/repos/jvdsandt/jvds-sudoku-model-kotlin/git/tags{/sha}",
    "git_refs_url": "https://api.github.com/repos/jvdsandt/jvds-sudoku-model-kotlin/git/refs{/sha}",
    "trees_url": "https://api.github.com/repos/jvdsandt/jvds-sudoku-model-kotlin/git/trees{/sha}",
    "statuses_url": "https://api.github.com/repos/jvdsandt/jvds-sudoku-model-kotlin/statuses/{sha}",
    "languages_url": "https://api.github.com/repos/jvdsandt/jvds-sudoku-model-kotlin/languages",
    "stargazers_url": "https://api.github.com/repos/jvdsandt/jvds-sudoku-model-kotlin/stargazers",
    "contributors_url": "https://api.github.com/repos/jvdsandt/jvds-sudoku-model-kotlin/contributors",
    "subscribers_url": "https://api.github.com/repos/jvdsandt/jvds-sudoku-model-kotlin/subscribers",
    "subscription_url": "https://api.github.com/repos/jvdsandt/jvds-sudoku-model-kotlin/subscription",
    "commits_url": "https://api.github.com/repos/jvdsandt/jvds-sudoku-model-kotlin/commits{/sha}",
    "git_commits_url": "https://api.github.com/repos/jvdsandt/jvds-sudoku-model-kotlin/git/commits{/sha}",
    "comments_url": "https://api.github.com/repos/jvdsandt/jvds-sudoku-model-kotlin/comments{/number}",
    "issue_comment_url": "https://api.github.com/repos/jvdsandt/jvds-sudoku-model-kotlin/issues/comments{/number}",
    "contents_url": "https://api.github.com/repos/jvdsandt/jvds-sudoku-model-kotlin/contents/{+path}",
    "compare_url": "https://api.github.com/repos/jvdsandt/jvds-sudoku-model-kotlin/compare/{base}...{head}",
    "merges_url": "https://api.github.com/repos/jvdsandt/jvds-sudoku-model-kotlin/merges",
    "archive_url": "https://api.github.com/repos/jvdsandt/jvds-sudoku-model-kotlin/{archive_format}{/ref}",
    "downloads_url": "https://api.github.com/repos/jvdsandt/jvds-sudoku-model-kotlin/downloads",
    "issues_url": "https://api.github.com/repos/jvdsandt/jvds-sudoku-model-kotlin/issues{/number}",
    "pulls_url": "https://api.github.com/repos/jvdsandt/jvds-sudoku-model-kotlin/pulls{/number}",
    "milestones_url": "https://api.github.com/repos/jvdsandt/jvds-sudoku-model-kotlin/milestones{/number}",
    "notifications_url": "https://api.github.com/repos/jvdsandt/jvds-sudoku-model-kotlin/notifications{?since,all,participating}",
    "labels_url": "https://api.github.com/repos/jvdsandt/jvds-sudoku-model-kotlin/labels{/name}",
    "releases_url": "https://api.github.com/repos/jvdsandt/jvds-sudoku-model-kotlin/releases{/id}",
    "deployments_url": "https://api.github.com/repos/jvdsandt/jvds-sudoku-model-kotlin/deployments",
    "created_at": 1492417334,
    "updated_at": "2019-05-23T17:09:23Z",
    "pushed_at": 1576487564,
    "git_url": "git://github.com/jvdsandt/jvds-sudoku-model-kotlin.git",
    "ssh_url": "git@github.com:jvdsandt/jvds-sudoku-model-kotlin.git",
    "clone_url": "https://github.com/jvdsandt/jvds-sudoku-model-kotlin.git",
    "svn_url": "https://github.com/jvdsandt/jvds-sudoku-model-kotlin",
    "homepage": null,
    "size": 56,
    "stargazers_count": 0,
    "watchers_count": 0,
    "language": "Kotlin",
    "has_issues": true,
    "has_projects": true,
    "has_downloads": true,
    "has_wiki": true,
    "has_pages": false,
    "forks_count": 0,
    "mirror_url": null,
    "archived": false,
    "disabled": false,
    "open_issues_count": 0,
    "license": null,
    "forks": 0,
    "open_issues": 0,
    "watchers": 0,
    "default_branch": "master",
    "stargazers": 0,
    "master_branch": "master"
  },
  "pusher": {
    "name": "jvdsandt",
    "email": "jvdsandt@gmail.com"
  },
  "sender": {
    "login": "jvdsandt",
    "id": 161266,
    "node_id": "MDQ6VXNlcjE2MTI2Ng==",
    "avatar_url": "https://avatars1.githubusercontent.com/u/161266?v=4",
    "gravatar_id": "",
    "url": "https://api.github.com/users/jvdsandt",
    "html_url": "https://github.com/jvdsandt",
    "followers_url": "https://api.github.com/users/jvdsandt/followers",
    "following_url": "https://api.github.com/users/jvdsandt/following{/other_user}",
    "gists_url": "https://api.github.com/users/jvdsandt/gists{/gist_id}",
    "starred_url": "https://api.github.com/users/jvdsandt/starred{/owner}{/repo}",
    "subscriptions_url": "https://api.github.com/users/jvdsandt/subscriptions",
    "organizations_url": "https://api.github.com/users/jvdsandt/orgs",
    "repos_url": "https://api.github.com/users/jvdsandt/repos",
    "events_url": "https://api.github.com/users/jvdsandt/events{/privacy}",
    "received_events_url": "https://api.github.com/users/jvdsandt/received_events",
    "type": "User",
    "site_admin": false
  },
  "created": false,
  "deleted": false,
  "forced": false,
  "base_ref": null,
  "compare": "https://github.com/jvdsandt/jvds-sudoku-model-kotlin/compare/285923417a54...db416c48d244",
  "commits": [
    {
      "id": "db416c48d24402035d2e4f7a48db8ae4621a630f",
      "tree_id": "c29d2222324cd25d8357d6ba1d362b73699a94dd",
      "distinct": true,
      "message": "Kotlin upgrade",
      "timestamp": "2019-12-16T10:10:59+01:00",
      "url": "https://github.com/jvdsandt/jvds-sudoku-model-kotlin/commit/db416c48d24402035d2e4f7a48db8ae4621a630f",
      "author": {
        "name": "Jan van de Sandt",
        "email": "jvdsandt@gmail.com",
        "username": "jvdsandt"
      },
      "committer": {
        "name": "Jan van de Sandt",
        "email": "jvdsandt@gmail.com",
        "username": "jvdsandt"
      },
      "added": [

      ],
      "removed": [

      ],
      "modified": [
        "pom.xml"
      ]
    }
  ],
  "head_commit": {
    "id": "db416c48d24402035d2e4f7a48db8ae4621a630f",
    "tree_id": "c29d2222324cd25d8357d6ba1d362b73699a94dd",
    "distinct": true,
    "message": "Kotlin upgrade",
    "timestamp": "2019-12-16T10:10:59+01:00",
    "url": "https://github.com/jvdsandt/jvds-sudoku-model-kotlin/commit/db416c48d24402035d2e4f7a48db8ae4621a630f",
    "author": {
      "name": "Jan van de Sandt",
      "email": "jvdsandt@gmail.com",
      "username": "jvdsandt"
    },
    "committer": {
      "name": "Jan van de Sandt",
      "email": "jvdsandt@gmail.com",
      "username": "jvdsandt"
    },
    "added": [

    ],
    "removed": [

    ],
    "modified": [
      "pom.xml"
    ]
  }
}'
]

{ #category : #'as yet unclassified' }
SPGitHubEventDataTest >> demoSignature [

	^ 'sha1=e63446d7fb12d515f8741cac6f1b656070b24e00'
]

{ #category : #'as yet unclassified' }
SPGitHubEventDataTest >> testAsSpiderUpdateJson [

	| data json |
	
	data := SPGitHubEventData new
		setEventName: self demoEvent guid: self demoGuid data: self demoPayload signature: self demoSignature;
		yourself.
		
	json := data asSpiderUpdateJson.
]

{ #category : #'as yet unclassified' }
SPGitHubEventDataTest >> testSignature [

	| data |
	
	data := SPGitHubEventData new
		setEventName: self demoEvent guid: self demoGuid data: self demoPayload signature: self demoSignature.
		
	self assert: data isSignatureCorrect
]
