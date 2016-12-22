module UsersHelper
  def prefixes
    %w(Mr Mrs Ms Miss Dr Sir)
  end

  def suffixes
    %w(PhD Jnr Snr)
  end

  def genders
    [['Male', 'm'], ['Female', 'f']]
  end

  def gender_icon(person, opts={})
    if person&.gender == 'm'
      icon_for 'male 1x', opts
    elsif person&.gender == 'f'
      icon_for 'female 1x', opts
    end
  end

  def avatar_url(person, size: 48)
    return person.avatar_url(size) if person&.avatar.present?
    return "https://graph.facebook.com/#{person.facebook}/picture?type=#{size > 72 ? 'large' : 'normal'}" if person&.facebook.to_i.to_s == person&.facebook
    return "https://twitter.com/#{person.twitter}/profile_image?size=#{size > 72 ? 'original' : 'normal'}" if person&.twitter
    gravatar_url(person&.email, size: size, default: :mm)
  end

  def avatar_tag(person, args={})
    args[:size] ||= avatar_size_from_class(args[:class].to_s.match(/avatar[^\s]*/).to_s)
    image_tag(avatar_url(person, size: args[:size]), class: "avatar #{args[:class]}")
  end

  def avatar_size_from_class(klass)
    if klass == 'avatar-xl'
      192
    elsif klass == 'avatar-md'
      72
    else
      48
    end
  end

  def current_church
    @current_church ||= Church.first || Church.new(name: 'Church-on-Rails')
  end

end
