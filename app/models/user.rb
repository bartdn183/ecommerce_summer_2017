class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

         has_many :orders, dependent: :destroy

         def admin?
         	role == "admin"
         end

         def guest?
         	role == "guest"
         end

         STATES = ["HI","AK","CA","OR","WA","ID","UT","NV","AZ","NM","CO","WY","MT","ND","SD","NB", "KS","OK","TX","LA","AR","MO","IA","MN","WI","IL","IN","MI","OH","KY","TN","MS","AL","GA","FL","SC","NC","VA","WV","DE","MD","PA","NY","NJ","CT","RI","MA","VT","NH","ME","DC"].sort!
end
