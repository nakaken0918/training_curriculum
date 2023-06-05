class CalendarsController < ApplicationController

  # １週間のカレンダーと予定が表示されるページ
  def index
    getWeek
    @plan = Plan.new
  end

  # 予定の保存
  def create
    Plan.create(plan_params)
    redirect_to action: :index
  end

  private

  def plan_params
    params.require(:plan).permit(:date, :plan)
  end

  def getWeek
    wdays = ['(日)','(月)','(火)','(水)','(木)','(金)','(土)']

    # Dateオブジェクトは、日付を保持しています。下記のように`.today.day`とすると、今日の日付を取得できます。
    @todays_date = Date.today
    # 例)　今日が2月1日の場合・・・ Date.today.day => 1日

    @week_days = []

    plans = Plan.where(date: @todays_date..@todays_date + 6)

    7.times do |x|
      today_plans = []
      plans.each do |plan|
        today_plans.push(plan.plan) if plan.date == @todays_date + x
      end
      # 今日の日付を取得し、+ x を追加。timesの実行毎に + 1 される。
      wday_num = Date.today.day + x
      # 中身の値を 0 ~ 6 のローテーションにしたいので、7 以上の場合に -7 を実行。
      if wday_num >= 7
        wday_num = wday_num -7
      end
      # 中身の値を曜日で表記したいので、wday_numに対応したwdaysを取り出すよう記述。wdays[wday_num]
      days = { :month => (@todays_date + x).month, :date => (@todays_date + x).day, :plans => today_plans, :wday => wdays[wday_num]}
      
      @week_days.push(days)
    end

  end
end
