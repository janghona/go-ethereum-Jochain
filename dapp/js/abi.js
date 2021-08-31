const abi = [
	{
		"constant": true,
		"inputs": [
			{
				"name": "",
				"type": "uint256"
			}
		],
		"name": "posts",
		"outputs": [
			{
				"name": "Num",
				"type": "uint256"
			},
			{
				"name": "UserName",
				"type": "string"
			},
			{
				"name": "UserPW",
				"type": "string"
			},
			{
				"name": "Title",
				"type": "string"
			},
			{
				"name": "maintext",
				"type": "string"
			},
			{
				"name": "timestamp",
				"type": "uint256"
			}
		],
		"payable": false,
		"stateMutability": "view",
		"type": "function"
	},
	{
		"constant": true,
		"inputs": [
			{
				"name": "_idx",
				"type": "uint256"
			}
		],
		"name": "getPost",
		"outputs": [
			{
				"name": "",
				"type": "uint256"
			},
			{
				"name": "",
				"type": "string"
			},
			{
				"name": "",
				"type": "string"
			},
			{
				"name": "",
				"type": "string"
			},
			{
				"name": "",
				"type": "uint256"
			}
		],
		"payable": false,
		"stateMutability": "view",
		"type": "function"
	},
	{
		"constant": false,
		"inputs": [
			{
				"name": "_UserName",
				"type": "string"
			},
			{
				"name": "_UserPW",
				"type": "string"
			},
			{
				"name": "_Title",
				"type": "string"
			},
			{
				"name": "_maintext",
				"type": "string"
			}
		],
		"name": "addPost",
		"outputs": [],
		"payable": false,
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"constant": true,
		"inputs": [],
		"name": "getTotal",
		"outputs": [
			{
				"name": "",
				"type": "uint256"
			}
		],
		"payable": false,
		"stateMutability": "view",
		"type": "function"
	},
	{
		"anonymous": false,
		"inputs": [
			{
				"indexed": false,
				"name": "Num",
				"type": "uint256"
			},
			{
				"indexed": false,
				"name": "UserName",
				"type": "string"
			},
			{
				"indexed": false,
				"name": "UserPW",
				"type": "string"
			},
			{
				"indexed": false,
				"name": "Title",
				"type": "string"
			},
			{
				"indexed": false,
				"name": "maintext",
				"type": "string"
			},
			{
				"indexed": false,
				"name": "timestamp",
				"type": "uint256"
			}
		],
		"name": "post",
		"type": "event"
	}
];