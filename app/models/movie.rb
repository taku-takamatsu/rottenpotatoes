class Movie < ActiveRecord::Base

    def self.all_ratings
        ['G','PG','PG-13','R']
    end

    def self.with_ratings(ratings)
        # if ratings_list is an array such as ['G', 'PG', 'R'], retrieve all
        #  movies with those ratings
        if ratings != nil
            self.where(:rating => ratings) 
        else
            self.all
        end
    end
end
