class Taxon
  attr_accessor :seq

  def initialize(id, branch=[])
    @seq = {id: id, branch: branch}
  end

  def id
    @seq[:id]
  end

  def branch
    @seq[:branch]
  end

  # Add child taxon to the branch
  # @param taxon the taxon to be added to the branch
  def add_taxon(taxon)
    @seq[:branch] << taxon
  end

  # Assigns an array of taxons to the branch
  # @param taxons an array of taxons
  def add_branch(taxons)
    @seq[:branch] = taxons
  end

  # return the taxon (tree branch) with the given ID or nil if not present
  # @param id the id of the taxon
  # @return the taxon or nil
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
  # @param category the category for which we need to find the parent
  # @return true if this taxon branch contains the category
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
  # @param category the category to be added to the tree
  # @return true if added, false otherwise
  def add_category_to_tree(category)
    if category_has_parent(category) && find_taxon(category.id).nil?
      find_taxon(category.parent_id).add_taxon Taxon.new(category.id)
      true
    end

    false
  end
end
