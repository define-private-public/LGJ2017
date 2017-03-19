# A goal data structre, it shouldn't get touched


import colors
import updateArguments
import drawArguments


type
  Goal* = ref GoalObj
  GoalObj = object of RootObj
    bounds*: Circle



proc newGoal*(): Goal =
  var app = getApp()

  result = new(Goal)
  result.bounds = newCircle(point2d(0, 0), app.worldScale * 0.065)

  


proc update*(
  self: Goal;
  app: App;
  ua: UpdateArguments
) =
  discard


proc draw*(
  self: Goal;
  app: App;
  da: DrawArguments
) =
  self.bounds.draw(colDimGray, Fill)

