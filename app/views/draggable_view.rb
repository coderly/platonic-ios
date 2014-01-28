class DraggableView < UIView
  include Event::Observable

  attr_accessor :destinationView
  def initWithFrame (rect)
    rmq.stylesheet = DraggableViewStylesheet

    if super
      add_gesture_recognizer
    end

    @picture = rmq.append(UIImageView, :picture).get

    @liked = rmq.append(UILabel, :liked).get
    @disliked = rmq.append(UILabel, :disliked).get

    self
  end
  
  private 
  def add_gesture_recognizer
    @panGesture = UIPanGestureRecognizer.alloc.initWithTarget(self, action:'drag_gesture:'); 
    
    self.addGestureRecognizer(@panGesture)
    self.userInteractionEnabled=true
    
  end
  
  def drag_gesture(panGesture)
    translation = panGesture.translationInView(self.superview)

    case panGesture.state
    when UIGestureRecognizerStateBegan
      @originalCenter = self.center
    when UIGestureRecognizerStateChanged
      self.center = CGPointMake(self.center.x + translation.x,
                                     self.center.y + translation.y)
      change_in_x = @originalCenter.x - self.center.x
      abs_change_in_x = change_in_x.abs

      rmq(self).style do |st|
        st.rotation = change_in_x * 0.09
      end
      rmq(@liked).style do |st|
        if change_in_x < 0
          st.view.alpha = abs_change_in_x * 0.01
        end
      end
      rmq(@disliked).style do |st|
        if change_in_x > 0
          st.view.alpha = abs_change_in_x * 0.01
        end
      end
      puts "Absolute change in x: #{abs_change_in_x}"
    when UIGestureRecognizerStateEnded
      self.center = CGPointMake(self.center.x + translation.x,
                                     self.center.y + translation.y)
      change_in_x = @originalCenter.x - self.center.x
      abs_change_in_x = change_in_x.abs

      if (@destinationView && CGRectContainsRect(@destinationView.frame, self.frame))
        self.removeGestureRecognizer(@panGesture)        
      elsif abs_change_in_x >= 90
        if change_in_x > 0
          puts "disliked"
          UIView.animateWithDuration(0.5,
           animations:lambda {
             self.center = CGPointMake(-1000,
                                     self.center.y + translation.y)
             },
            completion:lambda {|finished|

           })

        else
          puts "liked"
          UIView.animateWithDuration(0.5,
           animations:lambda {
             self.center = CGPointMake(1000,
                                     self.center.y + translation.y)
             },
            completion:lambda {|finished|

           })
        end
      else
        UIView.animateWithDuration(0.5,
             animations:lambda {
               self.center = @originalCenter
              rmq(self).style do |st|
                st.rotation = 0
              end
              rmq(@liked).style do |st|
                st.view.alpha = 0
              end
              rmq(@disliked).style do |st|
                st.view.alpha = 0
              end
             },
             completion:lambda {|finished|

             })
      end
    end
    
    panGesture.setTranslation(CGPointZero, inView:self.superview)
  end
  
end