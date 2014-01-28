class MenuViewController < UITableViewController

  def viewDidLoad
    rmq.stylesheet = MenuViewStylesheet
    rmq(self.view).apply_style :root_view

    @table_header_view = rmq.append(UIView, :table_header_view).get

    self.view.tableHeaderView = @table_header_view
	end

  def numberOfSectionsInTableView(tableView)
    1
  end

  def tableView(tableView, numberOfRowsInSection: section)
    case section
    when 0
      2
    end
  end

  def tableView(tableView, cellForRowAtIndexPath: indexPath)
    cell_identifier = self.class.name
    cell = tableView.dequeueReusableCellWithIdentifier(cell_identifier) || begin
      rmq.create(UITableViewCell, :cell).get
    end

    cell.selectionStyle = UITableViewCellSelectionStyleNone

	  menu_icon_area = rmq(cell).append(UIView, :menu_icon_area).get

    case indexPath.section
    when 0
      case indexPath.row
      when 0
        rmq(menu_icon_area).append(UIImageView, :pointer_icon)
        rmq(cell).append(UILabel, :home_label)
      when 1
        rmq(menu_icon_area).append(UIImageView, :messages_icon)
        rmq(cell).append(UILabel, :messages_label)
      end
    end

    cell
  end
end