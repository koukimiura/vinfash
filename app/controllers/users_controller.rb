class UsersController < ApplicationController
before_action :authenticate_user!, only: [:show, :likes, :likes_events, :events, :following, :followers]
before_action :ensure_correct_user, only:[:chats]
before_action :forbid_login_user

    def show
        @user = User.find(params[:id])
        @chat = Chat.new
        @friend = Friend.new
        @entry = @chat.entries.build
        @friend_following = Friend.where(follower: @user.id).count
        @friend_followers = Friend.where(followed: @user.id).count
        @relationship = "友人レベル"
        #my_shoe
        @shoe = Shoe.find_by(id: @user.shoe_id)
        #my_consumption
        @consumption = Consumption.find_by(id: @user.consumption_id)
        #user買い物エリア
        @chosen_area=[]
            MyArea.where(user_id: @user.id).each do |my|
                if Area.find(my.area_id)
                    @chosen_area.push(my.area_id) 
                end
            end
        
        
        #userチャットページ引き継ぎ 
        @current_userEntries = Entry.where(user_id: current_user.id)
        @userEntries = Entry.where(user_id: @user.id)
            @current_userEntries.each do |cu|
                @userEntries.each do |u|
                    if cu.chat_id == u.chat_id
                        @isChat = true
                        @chatId = cu.chat_id
                    end
                end
            end
    end
    
    def likes
        @user = User.find(params[:id])
        @likes = Like.where(user_id: @user.id)
        @chat = Chat.new
        @entry = @chat.entries.build
        @friend = Friend.new
        @friend_following = Friend.where(follower: @user.id).count
        @friend_followers = Friend.where(followed: @user.id).count
        @relationship = "友人レベル"
        #my_shoe
        @shoe = Shoe.find_by(id: @user.shoe_id)
        #my_consumption
        @consumption = Consumption.find_by(id: @user.consumption_id)
        #user買い物エリア
        @chosen_area=[]
            MyArea.where(user_id: @user.id).each do |my|
                if Area.find(my.area_id)
                    @chosen_area.push(my.area_id) 
                end
            end
    end
    
    
    
    def likes_events
        @user = User.find(params[:id])
        @likes = Like.where(user_id: @user.id)
        @chat = Chat.new
        @entry = @chat.entries.build
        @friend = Friend.new
        @friend_following = Friend.where(follower: @user.id).count
        @friend_followers = Friend.where(followed: @user.id).count
        @relationship = "友人レベル"
        #my_shoe
        @shoe = Shoe.find_by(id: @user.shoe_id)
        #my_consumption
        @consumption = Consumption.find_by(id: @user.consumption_id)
        #user買い物エリア
        @chosen_area=[]
            MyArea.where(user_id: @user.id).each do |my|
                if Area.find(my.area_id)
                    @chosen_area.push(my.area_id) 
                end
            end
    end
    

    def events
        @user = User.find(params[:id])
        @chat = Chat.new
        @entry = @chat.entries.build
        @friend = Friend.new
        @friend_following = Friend.where(follower: @user.id).count
        @friend_followers = Friend.where(followed: @user.id).count
        @relationship = "友人レベル"
        #my_shoe
        @shoe = Shoe.find_by(id: @user.shoe_id)
        #my_consumption
        @consumption = Consumption.find_by(id: @user.consumption_id)
        #user買い物エリア
        @chosen_area=[]
            MyArea.where(user_id: @user.id).each do |my|
                if Area.find(my.area_id)
                    @chosen_area.push(my.area_id) 
                end
            end
    end
    
    def chats
        @user = User.find(params[:id])
        #チャット作成
        @chat = Chat.new
        @entry = @chat.entries.build
        
        @friend = Friend.new
        @friend_following = Friend.where(follower: @user.id).count
        @friend_followers = Friend.where(followed: @user.id).count
        @relationship = "友人レベル"
        #my_shoe
        @shoe = Shoe.find_by(id: @user.shoe_id)
        #my_consumption
        @consumption = Consumption.find_by(id: @user.consumption_id)
        #user買い物エリア
        @chosen_area=[]
            MyArea.where(user_id: @user.id).each do |my|
                if Area.find(my.area_id)
                    @chosen_area.push(my.area_id) 
                end
            end
            
        #チャット一覧（最新メッセージ）
        #each文配列をmyChatIds代入
        #current_userの参加しているレコードを取得
        myChatIds = []
            Entry.where(user_id: current_user.id).each do |e|
                if Chat.find(e.chat_id)
                    myChatIds.push(e.chat_id)
                   # logger.debug("--------myEntries=#{myEntries}")
                end
            end
        #current_user.chat_idと同じchat_idを探してuser.id != current_user_idとする
        anotherEntries = Entry.where(chat_id: myChatIds).where('user_id != ?', current_user.id)
        #logger.debug("--------------anotherEntries=#{anotherEntries.inspect}")
        #自分のuser_idと参加しているchat_id
        myEntries = Entry.where(chat_id: myChatIds).where(user_id: current_user.id)
        #logger.debug("--------------myEntries=#{myEntries.inspect}")
        #チャットの最新のTalkレコードを取得
        talks=[] 
            anotherEntries.each do |an|
                myEntries.each do |e| 
                    if an.chat_id == e.chat_id #同じentry.idが複数入ってしまう。
                        talks.push(Talk.order(created_at: :desc)
                              .where(entry_id: [an.id, e.id]).first)
                    end
                end 
            end 
        
        #ChatレコードEntryレコードがcreateされたがTalkがされていないのtalksにはnilがある可能性があるcompackメソッドで弾く
        new_talks = talks.compact
        #logger.debug("--------------new_talks=#{new_talks.inspect}")
            
        talks_all = Talk.all.order(created_at: :desc)
        #順番揃える
        talks2=[]
            talks_all.each do |talk_all|
                new_talks.each do |talk|
                    if talk_all.id == talk.id
                        talks2.push(talk.id)
                    end
                end
            end
        
        #最終的配列 for view
        @talks3 = talks2.map do |t|
            Talk.find(t)
        end
        
        #一覧（相手の名前を出す。）
        #current_userのレコードを取得
        #@currentEntries = Entry.where(user_id: @user.id)
        #each文配列をmyRoomIds代入
        #myChatIds = []
        #current_userのレコードchat_idと同じchat.idを取得
        #@currentEntries.each do |e|
        #myChatIds << e.chat.id
        #end
        #current_user.chat_idと同じchat_idを探してuser.id != current_user_idとする
        #@anotherEntries = Entry.where(chat_id: myChatIds).where('user_id != ?', @user.id)
        #where.not
    end   
    
    
    def following
        @user = User.find(params[:id])
        @chat = Chat.new
        @entry = @chat.entries.build
        @friend = Friend.new
        @friend_following = Friend.where(follower: @user.id).count
        @friend_followers = Friend.where(followed: @user.id).count
        @relationship = "友人レベル"
        #my_shoe
        @shoe = Shoe.find_by(id: @user.shoe_id)
        #my_consumption
        @consumption = Consumption.find_by(id: @user.consumption_id)
        #user買い物エリア
        @chosen_area=[]
            MyArea.where(user_id: @user.id).each do |my|
                if Area.find(my.area_id)
                    @chosen_area.push(my.area_id) 
                end
            end
        
        
        
        #followingのアルゴリズム
        @friends =[]
        @request_friends =[]
        @my_friend_of_friends = []
        
            Friend.where(follower: current_user.id).each do |f|
                if Friend.find_by('follower = ? and followed = ?', f.followed, current_user.id)
                    @friends.push(f.followed)
                else
                    @request_friends.push(f.followed)
                end
            end
            
            Friend.where(follower: @user.id).each do |f|
                @my_friend_of_friends.push(f.followed)
            end
    end
    
    def followers
        @user = User.find(params[:id])
        @chat = Chat.new
        @entry = @chat.entries.build
        @friend = Friend.new
        @friend_following = Friend.where(follower: @user.id).count
        @friend_followers = Friend.where(followed: @user.id).count
        @relationship = "友人レベル"
        #my_shoe
        @shoe = Shoe.find_by(id: @user.shoe_id)
        #my_consumption
        @consumption = Consumption.find_by(id: @user.consumption_id)
        #user買い物エリア
        @chosen_area=[]
            MyArea.where(user_id: @user.id).each do |my|
                if Area.find(my.area_id)
                    @chosen_area.push(my.area_id) 
                end
            end
        #followedのアルゴリズム 
        @friends =[]
        @receive_friends =[]
        @my_friend_followers = []
        Friend.where(follower: current_user.id).each do |f|
            if Friend.find_by('follower = ? and followed = ?', f.followed, current_user.id)
                @friends.push(f.followed)
            end
        end
        
        Friend.where(followed: current_user.id).each do |f|
            if !Friend.find_by('follower = ? and followed = ?', current_user.id, f.follower)
                @receive_friends.push(f.follower)
            end
        end 
        
        Friend.where(followed: @user.id).each do |f|
            @my_friend_followers.push(f.follower)
        end
    end
    
    def ensure_correct_user
        @user = User.find(params[:id])
            if @user.id != current_user.id
                flash[:alert] = '権限はありません'
                redirect_to :back
            end
    end

end
