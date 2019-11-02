function addtolistbox(h,newitem,color)
    oldstring = get(h, 'string');
    if isempty(oldstring)
        newstring = newitem;
    elseif ~iscell(oldstring)
        newstring = {oldstring newitem};
    else
        newstring = {oldstring{:} newitem};
    end
    set(h,'ForegroundColor',color, 'string', newstring);
    drawnow
end