package utility {
	import flash.display.MovieClip;
	import components.Tag;
	import fl.transitions.Tween;
	import fl.transitions.easing.Strong;
	import fl.transitions.easing.Regular;
	import fl.transitions.TweenEvent;
	import flash.utils.setTimeout;
	import flash.display.DisplayObjectContainer;
	import components.Bubble;
	import components.Factoid;
	import utility.FactManager;
	
	public final class TagManager extends MovieClip {
		
		private static var _instance:TagManager;
		public var currentTags:Array = [];
		
		public var consolidatedTags:Array = [];
		
		private var currentQuestion:Number = 1;
		private var unlockedQuestionsStart:Array = [1, 90, 91, 99];
		private var unlockedQuestions:Array;
		
		public function TagManager() {
			if(_instance) {
				throw new Error("Singleton... use getInstance()");
			}
			_instance = this;
		}
		
		public static function getInstance():TagManager
		{
			if(!_instance)
			{
				new TagManager();
			}
			return _instance;
		}
		
		
		public function getQuestion()
		{
			unlockedQuestions.sort(Array.NUMERIC | Array.DESCENDING);
			var nextQ = unlockedQuestions.pop();
			return tags[nextQ];
		}
		
		public function clearTags()
		{
			unlockedQuestions = new Array();
			unlockedQuestions = unlockedQuestions.concat(unlockedQuestionsStart);
			currentTags = new Array();
		}
		
		public function addQuestions(q:Array)
		{
			for each(var question in q)
			{
				unlockedQuestions.push(question);
			}
		}
		
		public function addTag(tag:Tag):Array
		{
			currentTags.push(tag);
			stage.addChild(tag);
			return currentTags;
		}
		
		public function tagCount():Number
		{
			return currentTags.length;
		}
		
		public function submitTags(xPos:Number, yPos:Number):Number
		{
			var submitted:Number = currentTags.length;
			for(var i = 0; i < currentTags.length; i++)
			{
				var tag = currentTags[i];
				var createBubble = (i == 0) ? true : false;
				setTimeout(tagTween, i * 200, tag, xPos, yPos, createBubble);
			}
			return submitted;
		}
		
		private function tagTween(tag:MovieClip, xPos:Number, yPos:Number, createBubble:Boolean = false)
		{
			var tagTweenX:Tween = new Tween(tag, "x", Regular.easeIn, tag.x, xPos, 0.75, true); 
			var tagTweenY:Tween = new Tween(tag, "y", Regular.easeIn, tag.y, yPos, 0.75, true);
			var tagTweenScaleX:Tween = new Tween(tag, "scaleX", Regular.easeOut, 1, 0.5, 0.75, true);
			var tagTweenScaleY:Tween = new Tween(tag, "scaleY", Regular.easeOut, 1, 0.5, 0.75, true);
			tagTweenY.addEventListener(TweenEvent.MOTION_FINISH, destroyTag(tag, createBubble))
		}
		
		private function destroyTag(tag:MovieClip, createBubble:Boolean = false):Function
		{
			return function (e:TweenEvent):void
			{
				stage.removeChild(tag);
				Glob.getInstance().stats.updateTagStats();
				if(createBubble && FactManager.getInstance().factAvailable())
				{
					var factoid:MovieClip = new Factoid(tag.x, tag.y, stage);
					stage.addChild(factoid);
					//var bubble:Bubble = new Bubble(tag.x, tag.y);
					//stage.addChild(bubble);
				}
			}
		}
		
		public function consolidateTags()
		{
			consolidatedTags = new Array();
			for each(var tag in currentTags)
			{
				consolidatedTags.push(tag.tag);
			}
		}
		
		public var tags = {
			1: {
				kind: 1,
				question: "What can you see clearly in this photograph?",
				answers: {
					a: {
						title: "People",
						next: [20, 21, 22],
						tag: "people"
					},
					b: {
						title: "Aircraft",
						next: [30, 32],
						tag: "aircraft"
					},
					c: {
						title: "Vehicles",
						next: [41],
						tag: "ground-vehicle"
					},
					d: {
						title: "Animals",
						next: [51],
						tag: "animal"
					}
				}
			},
			20: {
				kind: 1,
				question: "What can you see in this photograph?",
				answers: {
					a: {
						title: "Man",
						tag: "men"
					},
					b: {
						title: "Woman",
						tag: "women"
					},
					c: {
						title: "Child",
						tag: "children"
					}
				}
			},
			21: {
				kind: 2,
				question: "Would you say the people look like they are at-work or at-leisure?",
				answers: {
					a: {
						title: "Work",
						tag: "work"
					},
					b: {
						title: "Leisure",
						tag: "leisure"
					},
					c: {
						title: "I'm unsure"
					}
				}
			},
			22: {
				kind: 2,
				question: "How many people can you see?",
				answers: {
					a: {
						title: "2 - 5",
						tag: "small-group"
					},
					b: {
						title: "6+",
						tag: "large-group"
					},
					c: {
						title: "one",
						tag: "one-person"
					}
				}
			},
			30: {
				kind: 2,
				question: "Can you see any aircraft in flight?",
				answers: {
					a: {
						title: "Yes",
						next: [33],
						tag: "in-flight"
					},
					b: {
						title: "No",
						next: [31]
					},
					c: {
						title: "I'm unsure"
					}
				}
			},
			31: {
				kind: 2,
				question: "Can you see any aircraft on the ground?",
				answers: {
					a: {
						title: "Yes",
						tag: "on-the-ground"
					},
					b: {
						title: "No"
					},
					c: {
						title: "I'm unsure"
					}
				}
			},
			32: {
				kind: 2,
				question: "Can you see any damage to the aircraft?",
				answers: {
					a: {
						title: "Yes",
						tag: "damage"
					},
					b: {
						title: "No"
					},
					c: {
						title: "I'm unsure"
					}
				}
			},
			33: {
				kind: 2,
				question: "Can you see an aircraft dropping bombs?",
				answers: {
					a: {
						title: "Yes",
						tag: "bomb-run"
					},
					b: {
						title: "No"
					},
					c: {
						title: "I'm unsure"
					}
				}
			},
			41: {
				kind: 1,
				question: "What type of vehicle can you see?",
				answers: {
					a: {
						title: "Car",
						tag: "car"
					},
					b: {
						title: "Other",
						tag: "other-vehicle"
					},
					c: {
						title: "Tank",
						tag: "tank"
					},
					d: {
						title: "Jeep",
						tag: "jeep"
					}
				}
			},
			51: {
				kind: 1,
				question: "What type of animal can you see?",
				answers: {
					a: {
						title: "Other",
						tag: "other"
					},
					b: {
						title: "Cat",
						tag: "cat"
					},
					c: {
						title: "Dog",
						tag: "dog"
					}
				}
			},
			90: {
				kind: 2,
				question: "Was the photograph taken indoors or outside?",
				answers: {
					a: {
						title: "Indoors",
						tag: "indoors"
					},
					b: {
						title: "Outside",
						tag: "outside"
					},
					c: {
						title: "I'm unsure"
					}
				}
			},
			91: {
				kind: 2,
				question: "Is this photograph in colour?",
				answers: {
					a: {
						title: "Yes",
						tag: "colour"
					},
					b: {
						title: "No",
						tag: "b-and-w"
					},
					c: {
						title: "I'm unsure"
					}
				}
			}
		}
	}
}
