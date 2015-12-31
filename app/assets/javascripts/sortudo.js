var app = angular.module('Sortudo', ['ngResource']);

app.factory("Player", [ "$resource",
	function($resource) {
   	return $resource("/players/:id", {
      id: "@id"
    	}, {
      update: {
        method: "PUT"
      },
			destroy: {
				method: "DELETE"
			},
			roll: {
				method: 'GET',
				url: '/roll/:id'
			},
			enough: {
				method: 'GET',
				url: '/enough/:id'
			}
    });
  }
]);


app.controller('SortudoCtrl', ['$scope', 'Player', function($scope, Player) {
	$scope.players = Player.query();
	
	$scope.addPlayer = function() {
	  var player = Player.save($scope.newPlayer);
	  $scope.players.push(player);
	  return $scope.newPlayer = {};
	};

	///
	// Clear scores to start a new game
	//
	$scope.newGame = function() {
	  angular.forEach($scope.players, function(player) {
			player.turn = 0;
			player.score = 0;
			player.dice_left = 5;
			player.turn_score = 0;
			player.roll_score = 0;
			player.last_dice = '[0, 0, 0, 0, 0]';
			player.able = true;
			player.winner = false;
			player.$update();
	  });
	};
	
	//
	// Oh my Gosh!
	// Help me, please
	//
	$scope.rollDice = function(player) {
		player.$roll();
		$scope.players = Player.query();
	};
	
	//
	// Let me friend be happy too
	//
	$scope.stopMe = function(player) {
		player.$enough();
		$scope.players = Player.query();
	};
	
	///
	// Drop all players
	//
	$scope.eraseAll = function() {
	  var player;
	  angular.forEach($scope.players, function(player) {
			player.$destroy();
	  });
		$scope.players = [];
	};
	
}]);
