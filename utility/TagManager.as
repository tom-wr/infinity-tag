package utility {
	import flash.display.MovieClip;
	import components.Tag;
	import fl.transitions.Tween;
	import fl.transitions.easing.Strong;
	import fl.transitions.easing.Regular;
	import fl.transitions.TweenEvent;
	import flash.utils.setTimeout;
	import flash.display.DisplayObjectContainer;
	
	public final class TagManager extends MovieClip {
		
		private static var _instance:TagManager;
		public var currentTags:Array = [];
		
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
			trace(unlockedQuestions);
			unlockedQuestions.sort(Array.NUMERIC | Array.DESCENDING);
			trace(unlockedQuestions);
			var nextQ = unlockedQuestions.pop();
			trace(unlockedQuestions);
			trace("next: " + nextQ);
			return tags[nextQ];
		}
		
		public function clearTags()
		{
			unlockedQuestions = new Array();
			unlockedQuestions = unlockedQuestions.concat(unlockedQuestionsStart);
			trace("new Array: " + unlockedQuestions);
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
				setTimeout(tagTween, i * 200, tag, xPos, yPos);
			}
			return submitted;
		}
		
		private function tagTween(tag:MovieClip, xPos:Number, yPos:Number)
		{
			var tagTweenX:Tween = new Tween(tag, "x", Regular.easeIn, tag.x, xPos, 0.75, true); 
			var tagTweenY:Tween = new Tween(tag, "y", Regular.easeIn, tag.y, yPos, 0.75, true);
			var tagTweenScaleX:Tween = new Tween(tag, "scaleX", Regular.easeOut, 1, 0.5, 0.75, true);
			var tagTweenScaleY:Tween = new Tween(tag, "scaleY", Regular.easeOut, 1, 0.5, 0.75, true);
			tagTweenY.addEventListener(TweenEvent.MOTION_FINISH, destroyTag(tag))
		}
		
		private function destroyTag(tag:MovieClip):Function
		{
			return function (e:TweenEvent):void
			{
				stage.removeChild(tag);
				Glob.getInstance().stats.updateTagStats();
			}
		}
		
		public var tags = {
			1: {
				kind: 1,
				question: "What can you see clearly in this photograph?",
				answers: {
					a: {
						title: "People",
						next: [20, 21],
						tag: "people"
					},
					b: {
						title: "Aircraft",
						next: [30, 32],
						tag: "aircraft"
					},
					c: {
						title: "Vehicles",
						tag: "ground-vehicle"
					},
					d: {
						title: "Animals",
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
			},
			11: {
				question: "Can you see any aircraft in this photograph?",
				answers: {
					a: {
						title: "Yes",
						tag: "aircraft"
					},
					b: {
						title: "No",
						tag: "no-aircraft"
					},
					c: {
						title: "I'm unsure"
					}
				}
			}
		}
	}
}
