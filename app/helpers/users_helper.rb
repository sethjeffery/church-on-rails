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
      fa_icon 'male 1x', opts
    elsif person&.gender == 'f'
      fa_icon 'female 1x', opts
    end
  end

  def avatar_url(person, size: 48)
    h gravatar_url(person.email, size: size, default: :mm)
  end

  def avatar_tag(person, args={})
    args[:size] ||= avatar_size_from_class(args[:class].match(/avatar[^\s]*/).to_s)
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
end
