class Taxon
  attr_accessor :seq

  def initialize(id, branch=[])
    @seq = {id: id, branch: branch}
  end

  def add_branch(taxons)
    @seq[:branch] = taxons
  end

  def add_taxon(taxon)
    @seq[:branch] << taxon
  end

  def id
    @seq[:id]
  end

  def branch
    @seq[:branch]
  end

  # return the taxon (tree branch) with the given ID or nil if not present
  def find_taxon(id)
    if @seq[:id] == id
      return self
    else
      if(@seq[:branch] == [])
        return nil
      else
        @seq[:branch].each do |b|
          return b.find_taxon( id )
        end
      end
    end
  end

  # verify that the parent of this category is present in the tree
  def category_has_parent(category)
    if @seq[:id] == category.parent_id
      return true
    else
      if(@seq[:branch] == [])
        return false
      else
        @seq[:branch].each do |b|
          return b.category_has_parent(category)
        end
      end
    end
  end


  # Add a category to a taxon tree
  def add_category_to_tree(category)
    if category_has_parent(category) && find_taxon(category.id).nil?
      find_taxon(category.parent_id).add_taxon Taxon.new(category.id)
      true
    end

    false
  end
end
