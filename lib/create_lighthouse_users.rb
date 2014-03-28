class CreateLighthouseUsers < Struct.new(:obj, :namespace)

  def create_users
    if obj.respond_to?(:assigned_lighthouse_user=)
      obj.assigned_lighthouse_user = create_user(obj.assigned_lighthouse_id)
    end
    if obj.respond_to?(:lighthouse_user=)
      obj.lighthouse_user = create_user(obj.lighthouse_id)
    end
  end

  def create_user(user_id)
    return unless user_id

    attributes = {
      lighthouse_id: user_id,
      namespace:     namespace
    }
    
    lh_user = LighthouseUser.where(attributes).first_or_initialize
    lh_user.update_from_api!(obj.token)
    lh_user
  end
end