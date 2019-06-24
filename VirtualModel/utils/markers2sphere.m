function markers_on_sphere = markers2sphere(markers, sphere, draw)
    markers_on_sphere = {};
    i=0;
    for marker = markers
        i=i+1;
        tf_to_marker =  sphere * marker{1};
        tf_to_marker(1:3,4) = tf_to_marker(1:3,4).*1000;
        markers_on_sphere{i} = tf_to_marker;
        if draw
            name = sprintf('mk-%d', i);
            DrawRefFrame(tf_to_marker,1,20,'_',name);
        end
    end
end

