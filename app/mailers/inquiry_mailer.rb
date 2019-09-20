class InquiryMailer < ApplicationMailer
    #default from: 'miurak565@gmail.com'
    
    def send_when_create(inquiry)
        @inquiry = inquiry
        mail to: ENV['USER_EMAIL'], subject: '『ポートフォリオ1.8』ユーザーからのお問い合わせ'
    end
    

    
    
end
