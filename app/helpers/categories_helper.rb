module CategoriesHelper

  def build_breadcrumbs(category)
    build_breadcrumbs(category.get_parent) unless category.parent_id.nil?
    add_breadcrumb "#{category.name}", category_path(category)
  end

  def print_taxon(taxon_tree, depth = 1)
    category = Category.find(taxon_tree.id)
    
    html_tree = "<div class='taxon-item'>#{"&nbsp;&nbsp;"*depth}#{ link_to category.name, category_path(category) }</div>"

    taxon_tree.branch.each { |t| html_tree += print_taxon(t, depth+1) }

    html_tree
  end
end
